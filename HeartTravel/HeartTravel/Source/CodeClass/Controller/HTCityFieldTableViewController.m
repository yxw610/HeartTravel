//
//  HTCityFieldTableViewController.m
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/19.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTCityFieldTableViewController.h"
#import "HTCityDetailsViewController.h"
#import "HTCityDetailsCell.h"
#import "HTCityDetailsModel.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "HTPlacesViewController.h"
#import "GetDataTools.h"
#import "HJNavigationController.h"

//屏幕尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HTCityFieldTableViewController ()

@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation HTCityFieldTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HTCityDetailsCell" bundle:nil] forCellReuseIdentifier:@"reuseIdentifier"];
    
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
//请求数据
- (void)requestURL {
    if ([self.urlArray[0] integerValue] == 0) {
        self.url = [NSString stringWithFormat:@"http://www.koubeilvxing.com/search?lat=0.000000&lng=0.000000&module=attraction&page=%ld&placeId=%@&rows=10",self.page,self.urlArray[1]];
    } else if ([self.urlArray[0] integerValue] == 1) {
        self.url = [NSString stringWithFormat:@"http://www.koubeilvxing.com/search?lat=0.000000&lng=0.000000&module=restaurant&page=%ld&placeId=%@&rows=10",self.page,self.urlArray[1]];
    } else if ([self.urlArray[0] integerValue] == 2) {
        self.url = [NSString stringWithFormat:@"http://www.koubeilvxing.com/search?lat=0.000000&lng=0.000000&module=hotel&page=%ld&placeId=%@&rows=10",self.page,self.urlArray[1]];
    } else if ([self.urlArray[0] integerValue] == 3) {
        self.url = [NSString stringWithFormat:@"http://www.koubeilvxing.com/search?lat=0.000000&lng=0.000000&module=shopping&page=%ld&placeId=%@&rows=10",self.page,self.urlArray[1]];
    } else {
        self.url = [NSString stringWithFormat:@"http://www.koubeilvxing.com/search?lat=0.000000&lng=0.000000&module=activity&page=%ld&placeId=%@&rows=10",self.page,self.urlArray[1]];
    }
    [self setUpDataWithStr:self.url];
}

- (void)loadNewData {
    self.page = 1;
    [self requestURL];
    // 刷新表格
    [self.tableView reloadData];
    // 拿到当前的下拉刷新控件，结束刷新状态
    [self.tableView.mj_header endRefreshing];
    
}

- (void)loadMoreData {
    self.page ++;
    [self requestURL];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
}

- (void)setUpDataWithStr:(NSString *)str {
    [[GetDataTools shareGetDataTools] getDataWithUrlString:str data:^(NSDictionary *dataDict) {
        for (NSDictionary *dict in dataDict[@"list"]) {
            HTCityDetailsModel *model = [HTCityDetailsModel new];
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
        for (NSDictionary *dict in dataDict[@"list"]) {
            HTCityDetailsModel *model = [HTCityDetailsModel new];
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
    
    
    return kScreenHeight / 2 - 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTCityDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    HTCityDetailsModel *model = self.dataArray[indexPath.row];
    [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.koubeilvxing.com/pics%@",model.path]]];
    cell.attractionName_cn.text = model.name_cn;
    cell.attractionName.text = model.name;
    cell.attractionScore.text = [NSString stringWithFormat:@"%@分/%@点评",model.score,model.reviewCount];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTPlacesViewController *placesTVC = [HTPlacesViewController new];
    HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:placesTVC];
    HTCityDetailsModel *model = self.dataArray[indexPath.row];
    placesTVC.recordId = model.ID;
    placesTVC.backView = model.path;
    [self presentViewController:nav animated:YES completion:nil];
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
