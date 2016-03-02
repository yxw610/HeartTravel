//
//  HTDiscoveryDetailViewController.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTDestinationStrategyController.h"
#import "HTDestinationStrategyCell.h"
#import "HTDestinationStrategy.h"
#import "HTDestinationRecordCell.h"
#import "HTTravelRecordModel.h"
#import "HTRecordContentModel.h"
#import "HTCityStrategyViewController.h"
#import "GetDataTools.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface HTDestinationStrategyController ()

@property (strong, nonatomic)NSMutableArray *dataArray;
@property (strong, nonatomic)NSMutableArray *recordArray;
@property (strong, nonatomic)NSMutableArray *cellHeightArray;

@end
// cell重用标识符
static NSString * const cellReuseID = @"cellReuseID";
static NSString * const cellReuseIdentifier = @"cellReuseIdentifier";

@implementation HTDestinationStrategyController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        self.cellHeightArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HTiconfont-fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction)];
    [self.tableView registerNib:[UINib nibWithNibName:@"HTDestinationStrategyCell" bundle:nil] forCellReuseIdentifier:cellReuseID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HTDestinationRecordCell" bundle:nil] forCellReuseIdentifier:cellReuseIdentifier];
    [self drawView];
    
}
- (void)drawView {
    NSString *string = [NSString stringWithFormat:@"http://q.chanyouji.com/api/v1/search.json?q=%@&search_type=destination",self.stringID];

    [[GetDataTools shareGetDataTools] getDataWithUrlString:string data:^(NSDictionary *dataDict) {
        self.dataArray = [NSMutableArray arrayWithCapacity:7];
        for (NSDictionary *dict in dataDict[@"data"][@"destinations"]) {
            HTDestinationStrategy *model = [HTDestinationStrategy new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        self.recordArray = [NSMutableArray arrayWithCapacity:17];
        for (NSDictionary *dic in dataDict[@"data"][@"user_activities"]) {
            HTTravelRecordModel *model = [HTTravelRecordModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.recordArray addObject:model];
            NSArray *heightArray = [HTDestinationRecordCell caculateHeightForLabelWithModel:model];
            CGFloat recordContentViewHeight = [heightArray[2] floatValue];
            [self.cellHeightArray addObject:@(recordContentViewHeight)];
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
    if (self.dataArray.count == 0) {
        return 1;
    }else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.dataArray.count != 0) {
        return self.dataArray.count;
    }else {
        return self.recordArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.dataArray.count != 0) {
        HTDestinationStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID forIndexPath:indexPath];
        HTDestinationStrategy *model = self.dataArray[indexPath.row];
        cell.detail = model;
        
        return cell;
    }else {
        HTDestinationRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HTTravelRecordModel *model = self.recordArray[indexPath.row];
        [cell setCellValueWithModel:model imgViewHeight:kScreenWidth * ((HTRecordContentModel *)model.contents[0]).height / ((HTRecordContentModel *)model.contents[0]).width recordContentViewHeight:[self.cellHeightArray[indexPath.row] floatValue]];
        
        cell.showWholeRecordBlock = ^(HTDestinationRecordCell *currentCell) {
            
            NSIndexPath *indexRow = [self.tableView indexPathForCell:currentCell];
            
            NSArray *heightArray = [HTDestinationRecordCell caculateHeightForLabelWithModel:model];
            
            self.cellHeightArray[indexRow.row] = @([heightArray[0] floatValue] + [heightArray[1] floatValue]);
            
            [self.tableView reloadRowsAtIndexPaths:@[indexRow] withRowAnimation:UITableViewRowAnimationAutomatic];
            //  currentCell.wholeContentButton.hidden = YES;
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.dataArray.count != 0) {
        HTDestinationStrategy *model = self.dataArray[indexPath.row];
        HTCityStrategyViewController *cityStrategyVC = [HTCityStrategyViewController new];
        cityStrategyVC.strategyID = model.ID;
        cityStrategyVC.nameString = model.name;
        [self.navigationController pushViewController:cityStrategyVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.dataArray.count != 0) {
        return kScreenHeight/23 *4;
    }else {
        HTTravelRecordModel *model = self.recordArray[indexPath.row];
        CGFloat imgHeight = kScreenWidth * ((HTRecordContentModel *)model.contents[0]).height / ((HTRecordContentModel *)model.contents[0]).width;
        
        CGFloat recordContentViewHeight = [self.cellHeightArray[indexPath.row] floatValue];
        
        CGFloat cellHeight = 40+ imgHeight + recordContentViewHeight;
        
        return cellHeight;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.dataArray.count != 0) {
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth, kScreenHeight/20)];
        header.text = @"   目的地攻略";
        header.font = [UIFont systemFontOfSize:15];
        return header;
    }else {
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth, kScreenHeight/20)];
        header.text = @"   相关氢游记";
        header.font = [UIFont systemFontOfSize:15];
        return header;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kScreenHeight/20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}
- (void)click {
    NSLog(@"==");
    
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
