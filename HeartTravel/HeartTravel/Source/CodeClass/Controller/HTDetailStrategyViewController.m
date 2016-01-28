//
//  HTDetailStrategyViewController.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/26.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTDetailStrategyViewController.h"
#import "HTDetailStrategyModel.h"
#import "HTDetailStrategyCell.h"
#import "HJTableViewHeader.h"
#import "HJNavigationBar.h"
#import "HTDistrictModel.h"
#import "GetDataTools.h"
#import <UIImageView+WebCache.h>

@interface HTDetailStrategyViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong)UITableView* tableView;
@property (nonatomic,strong)HJTableViewHeader* headView;
@property (nonatomic,strong)UIImageView* bigImageView;
/**
 *  数据数组
 */
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation HTDetailStrategyViewController

- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HTDetailStrategyCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self drawView];
    [self getData];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HTiconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction)];

}
- (void)drawView {
    _bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    //[self.bigImageView sd_setImageWithURL:[NSURL URLWithString:@"http://inspiration.chanyouji.cn/InspirationActivity/5/89dfb918a7d68f0b5f9f8b177159070d.jpg"]];
    _bigImageView.clipsToBounds = YES;
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headView = [[HJTableViewHeader alloc]init];
    [_headView goodMenWithTableView:self.tableView andBackGroundView:_bigImageView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavbarBackgroundHidden:YES];
}
- (void)getData {
    NSString *string = [NSString stringWithFormat:@"http://q.chanyouji.com/api/v1/inspiration_activities/%@.json",self.detailID];
    self.dataArray = [NSMutableArray array];
    [[GetDataTools shareGetDataTools] getDataWithUrlString:string data:^(NSDictionary *dataDict) {
        HTDetailStrategyModel *model = [HTDetailStrategyModel new];
        [model setValuesForKeysWithDictionary:dataDict[@"data"]];
        [self.dataArray addObject:model];
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.cropping_url]];
        // 返回主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
      });
    }];
}
- (void)leftButtonAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setNavbarBackgroundHidden:(BOOL)hidden {
    
    HJNavigationBar *navBar = (HJNavigationBar *)self.navigationController.navigationBar;
    if (!hidden) {
        [navBar show];
    } else {
        [navBar hidden];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HTDetailStrategyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    HTDetailStrategyModel *model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellValueWithModel:model];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTDetailStrategyModel *model = self.dataArray[indexPath.row];
    NSArray *heightArray = [HTDetailStrategyCell caculateHeightForLabelWithModel:model];
    CGFloat contentHeight = [heightArray[2] floatValue]+ 90;
    return contentHeight;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_headView scrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y < self.bigImageView.frame.size.height - 64) {
        [self setNavbarBackgroundHidden:YES];
    } else {
        
        [self setNavbarBackgroundHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
