//
//  HTCityTableViewController.m
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/18.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTCityTableViewController.h"
#import "HTCityCell.h"
#import <MJRefresh.h>
#import "HTCityModel.h"
#import <UIImageView+WebCache.h>
#import "HTCityDetailsViewController.h"
#import "GetDataTools.h"
//屏幕尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HTCityTableViewController ()

@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation HTCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"HTCityCell" bundle:nil] forCellReuseIdentifier:@"reuseIdentifier"];
    
    NSString *str = [NSString stringWithFormat:@"http://www.koubeilvxing.com/places?countryId=%@page=%ld&rows=10",self.ID,self.page];
    
    [self setUpDataWithStr:str];
    
    //MJ刷新
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    //设置导航栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HTiconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction)];
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationItem.title = [NSString stringWithFormat:@"%@热门城市",self.titleName];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(rightButtonAction)];
}

- (void)leftButtonAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightButtonAction {
    
    
}

- (void)loadNewData {
    self.page = 1;
    NSString *str = [NSString stringWithFormat:@"http://www.koubeilvxing.com/places?countryId=%@&page=%ld&rows=10",self.ID,self.page];
    [self setUpDataWithString:str];
    // 刷新表格
    [self.tableView reloadData];
    // 拿到当前的下拉刷新控件，结束刷新状态
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData {
    
    self.page ++;
    NSString *str = [NSString stringWithFormat:@"http://www.koubeilvxing.com/places?countryId=%@&page=%ld&rows=10",self.ID,self.page];
    [self setUpDataWithStr:str];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    
}

- (void)setUpDataWithStr:(NSString *)str {
    
    [[GetDataTools shareGetDataTools] getDataWithUrlString:str data:^(NSDictionary *dataDict) {
        for (NSDictionary *dict in dataDict[@"places"]) {
            HTCityModel *model = [HTCityModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)setUpDataWithString:(NSString *)str {
    
    [[GetDataTools shareGetDataTools] getDataWithUrlString:str data:^(NSDictionary *dataDict) {
        self.dataArr = [NSMutableArray array];
        for (NSDictionary *dict in dataDict[@"places"]) {
            HTCityModel *model = [HTCityModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArr addObject:model];
        }
        self.dataArray = self.dataArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenHeight / 3.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    HTCityModel *model = self.dataArray[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"http://img.koubeilvxing.com/pics%@",model.path];
    [cell.cityImage sd_setImageWithURL:[NSURL URLWithString:str]];
    NSString *cityName = [NSString stringWithFormat:@"%@(%@)",model.name_cn,model.name];
    cell.cityName.text = cityName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTCityModel *model = self.dataArray[indexPath.row];
    HTCityDetailsViewController *cityDetailsVC = [[HTCityDetailsViewController alloc] initWithPlaceID:model.ID];
    cityDetailsVC.headerName = model.name_cn;
    [self.navigationController pushViewController:cityDetailsVC animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
