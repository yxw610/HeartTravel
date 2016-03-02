//
//  HTStrategyTableViewController.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTStrategyTableViewController.h"
#import "HTStrategyTableViewCell.h"
#import "HTStrategyModel.h"
#import "HTStrategyPhoto.h"
#import "HTDetailStrategyViewController.h"
#import "HJNavigationController.h"
#import "GetDataTools.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HTStrategyTableViewController ()<moreDetailDelegate>

@property (strong, nonatomic)NSMutableDictionary *foldDict;
/**
 *  分组名数组
 */
@property (strong, nonatomic)NSMutableArray *group;
/**
 *  所有对象的容器
 */
@property (strong, nonatomic)NSMutableDictionary *dataDictionary;

@end
/**
 *  cell重用标识符
 */
static NSString *const cellReuseIdentifier = @"cellReuseIdentifier";
@implementation HTStrategyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.categaryName;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HTiconfont-fanhui"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction)];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HTStrategyTableViewCell" bundle:nil] forCellReuseIdentifier:cellReuseIdentifier];
    self.foldDict = [NSMutableDictionary dictionary];
    [self drawView];
}
- (void)drawView {
    NSString *urlString = [NSString stringWithFormat:@"http://q.chanyouji.com/api/v1/activity_collections/%@.json",self.string];
    self.dataDictionary = [NSMutableDictionary dictionary];
    self.group = [NSMutableArray array];
    [[GetDataTools shareGetDataTools] getDataWithUrlString:urlString data:^(NSDictionary *dataDict) {
        for (NSDictionary *dict in dataDict[@"data"]) {
            HTStrategyModel *model = [HTStrategyModel new];
            [model setValuesForKeysWithDictionary:dict];
            NSMutableArray *tempGroup = [NSMutableArray array];
            [tempGroup addObject:model];
            [self.dataDictionary setObject:tempGroup forKey:model.topic];
            [self.group addObject:model.topic];
        }
        // 返回主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}
- (void)leftButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.group.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.foldDict valueForKey:[NSString stringWithFormat:@"%ld",section]] boolValue]) {
        return [self.dataDictionary[self.group[section]] count];
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTStrategyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HTStrategyModel *model = self.dataDictionary[self.group[indexPath.section]][indexPath.row];
    CGFloat imgHeight = (kScreenWidth - 20) * model.photo.height/model.photo.width;
    CGFloat contentHeight = [HTStrategyTableViewCell caculateHeightForLabelWithModel:model];
    [cell setCellValueWithModel:model ImgViewHeight:imgHeight contentLabelHeight:contentHeight];
 
    return cell;
}
/**
 *  实现自定义cell的代理方法
 *
 *  @param cell 点击的cell
 */
- (void)moreDetailClick:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HTStrategyModel *model = self.dataDictionary[self.group[indexPath.section]][indexPath.row];
    HTDetailStrategyViewController *detailVC = [HTDetailStrategyViewController new];
    HJNavigationController *naVC = [[HJNavigationController alloc] initWithRootViewController:detailVC];
    detailVC.detailID = model.strategy_id;
    [self presentViewController:naVC animated:YES completion:nil];
}
// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTStrategyModel *model = self.dataDictionary[self.group[indexPath.section]][indexPath.row];
    CGFloat imgHeight = (kScreenWidth - 20) * model.photo.height/model.photo.width;
    CGFloat contentModel = [HTStrategyTableViewCell caculateHeightForLabelWithModel:model];
    CGFloat cellHeight = 35 + imgHeight + contentModel;
    
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button setTitle:[NSString stringWithFormat:@"%@",self.group[section]] forState:(UIControlStateNormal)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.tag = 1000 + section;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (void)buttonAction:(UIButton *)sender {
    NSUInteger section = sender.tag - 1000;
    if ([[self.foldDict valueForKey:[NSString stringWithFormat:@"%ld",section]] boolValue] == NO) {
        [self.foldDict setValue:@(YES) forKey:[NSString stringWithFormat:@"%ld",section]];
    }else {
        [self.foldDict setValue:@(NO) forKey:[NSString stringWithFormat:@"%ld",section]];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationLeft)];
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
