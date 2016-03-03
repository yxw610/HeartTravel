//
//  HTCityStrategyViewController.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTCityStrategyViewController.h"
#import "HTCityStrategyModel.h"
#import "HTCityStrategyCell.h"
#import "HTStrategyTableViewController.h"
#import "GetDataTools.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface HTCityStrategyViewController ()
@property (strong,nonatomic)NSMutableArray *array;
@end
// cell重用标识符
static NSString *const cellReuseID = @"cellReuseIdentifier";

@implementation HTCityStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@攻略",self.nameString];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HTiconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction)];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HTCityStrategyCell" bundle:nil] forCellReuseIdentifier:cellReuseID];
    
    [self drawView];
}
- (void)drawView {
    NSString *urlString = [NSString stringWithFormat:@"http://q.chanyouji.com/api/v1/activity_collections.json?destination_id=%@",self.strategyID];
    [[GetDataTools shareGetDataTools] getDataWithUrlString:urlString data:^(NSDictionary *dataDict) {
        self.array = [NSMutableArray arrayWithCapacity:11];
        for (NSDictionary *dict in dataDict[@"data"]) {
            HTCityStrategyModel *model = [HTCityStrategyModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.array addObject:model];
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

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTCityStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HTCityStrategyModel *model = self.array[indexPath.row];
    cell.model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTStrategyTableViewController *strategyVC = [[HTStrategyTableViewController alloc] initWithStyle:(UITableViewStyleGrouped)];
    HTCityStrategyModel *model = self.array[indexPath.row];
    strategyVC.string = model.city_id;
    strategyVC.categaryName = model.topic;
    [self.navigationController pushViewController:strategyVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight/9*2;
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
