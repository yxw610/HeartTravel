//
//  HTTravelRecordTableViewController.m
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTTravelRecordTableViewController.h"
#import "HTTravelRecordTableViewCell.h"
#import "HTTravelRecordModel.h"
#import "HTRecordContentModel.h"
#import "GetDataTools.h"

#define kURL @"http://q.chanyouji.com/api/v1/timelines.json?page=1&per=50"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static NSString * const HTTravelRecordCellID = @"HTTravelRecordCellIdentifier";

@interface HTTravelRecordTableViewController ()

@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *cellMarkArray;
@property (strong, nonatomic) NSMutableArray *cellHeightArray;

@end

@implementation HTTravelRecordTableViewController


- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        
        self.cellHeightArray = [NSMutableArray array];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"HTTravelRecordTableViewCell" bundle:nil] forCellReuseIdentifier:HTTravelRecordCellID];
    
    
    
    __unsafe_unretained typeof(self) weakSelf = self;
    self.cellHeightArray = [NSMutableArray array];
    
    [[GetDataTools shareGetDataTools] getDataWithUrlString:kURL data:^(NSDictionary *dataDict) {
        
        NSDictionary *dict = dataDict;
        weakSelf.array = [NSMutableArray array];
        weakSelf.cellMarkArray = [NSMutableArray array];
        
        for (NSDictionary *tempDict in dict[@"data"]) {
            
            HTTravelRecordModel *recordModel = [HTTravelRecordModel new];
            
            [recordModel setValuesForKeysWithDictionary:tempDict[@"activity"]];
            
            NSArray *heightArray = [HTTravelRecordTableViewCell caculateHeightForLabelWithModel:recordModel];
            
            CGFloat recordContentViewHeight = [heightArray[2] floatValue];
            
            [weakSelf.cellHeightArray addObject:@(recordContentViewHeight)];
            
            [weakSelf.array addObject:recordModel];
            [weakSelf.cellMarkArray addObject:@"part"];
            
        }
        
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

    
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HTTravelRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HTTravelRecordCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HTTravelRecordModel *model = self.array[indexPath.row];
    
    [cell setCellValueWithModel:model imgViewHeight:kScreenWidth * ((HTRecordContentModel *)model.contents[0]).height / ((HTRecordContentModel *)model.contents[0]).width recordContentViewHeight:[self.cellHeightArray[indexPath.row] floatValue]];
    
    cell.showWholeRecordBlock = ^(HTTravelRecordTableViewCell *currentCell) {
        
        NSIndexPath *indexRow = [self.tableView indexPathForCell:currentCell];
        
        NSArray *heightArray = [HTTravelRecordTableViewCell caculateHeightForLabelWithModel:model];
        
        self.cellHeightArray[indexRow.row] = @([heightArray[0] floatValue] + [heightArray[1] floatValue]);
        
        [self.tableView reloadRowsAtIndexPaths:@[indexRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        //        currentCell.wholeContentButton.hidden = YES;
        
    };
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        
    HTTravelRecordModel *model = self.array[indexPath.row];
    CGFloat imgHeight = kScreenWidth * ((HTRecordContentModel *)model.contents[0]).height / ((HTRecordContentModel *)model.contents[0]).width;
    
    CGFloat recordContentViewHeight = [self.cellHeightArray[indexPath.row] floatValue];
    
    CGFloat cellHeight = 110 + kScreenWidth / 4 + imgHeight + recordContentViewHeight;
    
    return cellHeight;

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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
