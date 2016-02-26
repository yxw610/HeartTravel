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
#import <RESideMenu/RESideMenu.h>
#import "HTDiscoveryHotViewController.h"

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

    self.navigationItem.title = @"游记";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HTHome_Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(leftMenuAction:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发现" style:UIBarButtonItemStylePlain target:self action:@selector(discoveryHotViewAction:)];
    
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

// 返回左边菜单栏
- (void)leftMenuAction:(UIBarButtonItem *)sender {
    
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)discoveryHotViewAction:(UIBarButtonItem *)sender {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    HTDiscoveryHotViewController *discoryHotVC = [[HTDiscoveryHotViewController alloc] initWithCollectionViewLayout:flowLayout];

    [self.navigationController pushViewController:discoryHotVC animated:YES];
}

@end
