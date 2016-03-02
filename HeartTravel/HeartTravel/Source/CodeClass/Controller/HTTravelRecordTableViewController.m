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
#import "AVOSCloud/AVOSCloud.h"
#import "HTDistrictModel.h"
#import "MJRefresh.h"
#import "HTUserModel.h"
#import "HTRecordContentModel.h"
#import "HTFileService.h"

#define kURL @"http://q.chanyouji.com/api/v1/timelines.json?page=1&per=50"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static NSString * const HTTravelRecordCellID = @"HTTravelRecordCellIdentifier";

@interface HTTravelRecordTableViewController ()

@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *cellMarkArray;
@property (strong, nonatomic) NSMutableArray *cellHeightArray;
@property (assign, nonatomic) NSInteger loadNum;

@end

@implementation HTTravelRecordTableViewController


- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        
        self.cellHeightArray = [NSMutableArray array];
        self.loadNum = 1;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"游记";
    
    
    
    UIImage * normalImg = [UIImage imageNamed:@"HTHome_Menu"];
    normalImg = [normalImg imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:normalImg style:UIBarButtonItemStylePlain target:self action:@selector(leftMenuAction:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发现" style:UIBarButtonItemStylePlain target:self action:@selector(discoveryHotViewAction:)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HTTravelRecordTableViewCell" bundle:nil] forCellReuseIdentifier:HTTravelRecordCellID];

    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    
}


// 清除缓存
- (void)clearCache {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    [HTFileService clearCache:cachesPath];
    
}

- (void)showRecordInfo {
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [[GetDataTools shareGetDataTools] getDataWithUrlString:kURL data:^(NSDictionary *dataDict) {
        
        NSDictionary *dict = dataDict;
        weakSelf.array = [NSMutableArray array];
        weakSelf.cellMarkArray = [NSMutableArray array];
        weakSelf.cellHeightArray = [NSMutableArray array];
        
        for (NSDictionary *tempDict in dict[@"data"]) {
            
            HTTravelRecordModel *recordModel = [HTTravelRecordModel new];
            
            [recordModel setValuesForKeysWithDictionary:tempDict[@"activity"]];
            recordModel.groupNum = 0;
            
            [self updateURLRecord:recordModel];
            
            NSArray *heightArray = [HTTravelRecordTableViewCell caculateHeightForLabelWithModel:recordModel];
            
            CGFloat recordContentViewHeight = [heightArray[2] floatValue];
            
            [weakSelf.cellHeightArray addObject:@(recordContentViewHeight)];
            
            [weakSelf.array addObject:recordModel];
            [weakSelf.cellMarkArray addObject:@"part"];
            
        }
        
        [weakSelf getLeanCloudData];
        
    }];
}

- (void)headerRefreshAction {
    
    self.loadNum = 1;
    [self clearCache];
    
    __unsafe_unretained typeof(self) weakSelf = self;

    [[GetDataTools shareGetDataTools] getDataWithUrlString:kURL data:^(NSDictionary *dataDict) {
        
        NSDictionary *dict = dataDict;
        weakSelf.array = [NSMutableArray array];
        weakSelf.cellMarkArray = [NSMutableArray array];
        weakSelf.cellHeightArray = [NSMutableArray array];
        
        for (NSDictionary *tempDict in dict[@"data"]) {
            
            HTTravelRecordModel *recordModel = [HTTravelRecordModel new];
            
            [recordModel setValuesForKeysWithDictionary:tempDict[@"activity"]];
            recordModel.groupNum = 0;
            
            [self updateURLRecord:recordModel];
            
            NSArray *heightArray = [HTTravelRecordTableViewCell caculateHeightForLabelWithModel:recordModel];
            
            CGFloat recordContentViewHeight = [heightArray[2] floatValue];
            
            [weakSelf.cellHeightArray addObject:@(recordContentViewHeight)];
            
            [weakSelf.array addObject:recordModel];
            [weakSelf.cellMarkArray addObject:@"part"];
            
        }

        [weakSelf getLeanCloudData];
        
    }];
}

- (void)updateURLRecord:(HTTravelRecordModel *)model {
    
    AVQuery *recordQuery = [AVQuery queryWithClassName:@"URLRecord"];
    [recordQuery whereKey:@"model_id" equalTo:@(model.model_id)];
    [recordQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            
        } else if (objects.count == 0) {
            
            AVObject *record = [AVObject objectWithClassName:@"URLRecord"];
            record[@"comments_count"] = @(model.comments_count);
            record[@"contents_count"] = @(model.contents_count);
            NSMutableArray *array = [NSMutableArray array];
            for (HTRecordContentModel *content in model.contents) {
                
                NSData *contentData = [NSKeyedArchiver archivedDataWithRootObject:content];
                [array addObject:contentData];
            }
            record[@"contents"] = array;
            record[@"created_at"] = model.created_at;
            record[@"desc"] = model.desc;
            record[@"district_id"] = @(model.district_id);
            
            NSMutableArray *districtArray = [NSMutableArray array];
            for (int i = 0; i < model.districts.count; i++) {
                
                HTDistrictModel *district = model.districts[i];
                NSData *districtData = [NSKeyedArchiver archivedDataWithRootObject:district];
                [districtArray addObject:districtData];
            }
            record[@"districts"] = districtArray;
            
            record[@"favorites_count"] = @(model.favorites_count);
            record[@"model_id"] = @(model.model_id);
            record[@"likes_count"] = @(model.likes_count);
            record[@"topic"] = model.topic;
            record[@"user_id"] = @(model.userInfo.user_id);
            
            [record saveInBackground];
        }
    }];
    
}

- (void)footerRefreshAction {
    
    self.loadNum += 1;
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    NSString *urlString = [NSString stringWithFormat:@"http://q.chanyouji.com/api/v1/timelines.json?page=%ld&per=50",self.loadNum];
    NSLog(@"%@",urlString);
    
    [[GetDataTools shareGetDataTools] getDataWithUrlString:urlString data:^(NSDictionary *dataDict) {
        
        NSDictionary *dict = dataDict;
        
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
            [self.tableView.mj_footer endRefreshing];
        });
        
    }];
    
}

- (void)getLeanCloudData {
    
    AVQuery *query = [AVQuery queryWithClassName:@"TravelRecord"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSArray<AVObject *> *models = objects;
        if (models.count > 0) {
            
            NSMutableArray *array = [NSMutableArray array];
            NSMutableArray *cellHeightArray = [NSMutableArray array];
            NSMutableArray *cellMarkArray = [NSMutableArray array];
            
            for (NSInteger i = models.count - 1; i >= 0; i--) {
                
                AVObject *travelRecord = models[i];
                
                HTTravelRecordModel *model = [[HTTravelRecordModel alloc] init];
                
                model.topic = travelRecord[@"topic"];
                model.desc = travelRecord[@"desc"];
                model.contents_count = [travelRecord[@"content_count"] integerValue];
                
                // 用户信息
                AVQuery *userQuery = [AVQuery queryWithClassName:@"UserInfo"];
                [userQuery whereKey:@"user_id" equalTo:travelRecord[@"user_id"]];
                NSArray *userArray = [userQuery findObjects];
                AVObject *userInfo = [userArray firstObject];
                HTUserModel *userModel = [[HTUserModel alloc] init];
                userModel.user_id = [userInfo[@"user_id"] integerValue];
                userModel.gender = [userInfo[@"gender"] integerValue];
                userModel.name = userInfo[@"name"];
                userModel.photo_url = userInfo[@"photo_url"];
                model.userInfo = userModel;

                NSMutableArray *contents = [NSMutableArray array];
                contents = travelRecord[@"contents"];
                NSMutableArray *modelContents = [NSMutableArray array];
                
                for (NSData *data in contents) {
                    
                    HTRecordContentModel *recordContentModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    
                    [modelContents addObject:recordContentModel];
                }
                model.contents = modelContents;
                
                NSMutableArray *districts = travelRecord[@"districts"];
                NSMutableArray *districtsArray = [NSMutableArray array];
                
                for (NSData *districtData in districts) {
                    
                    HTDistrictModel *districtModel = [NSKeyedUnarchiver unarchiveObjectWithData:districtData];
                    
                    [districtsArray addObject:districtModel];
                }
                model.districts = districtsArray;
                model.model_id = [travelRecord[@"model_id"] integerValue];
                model.groupNum = 1;
                
                NSArray *heightArray = [HTTravelRecordTableViewCell caculateHeightForLabelWithModel:model];
                
                CGFloat recordContentViewHeight = [heightArray[2] floatValue];

                
                [cellHeightArray addObject:@(recordContentViewHeight)];
                [cellMarkArray addObject:@"part"];
                [array addObject:model];
                
                
            }
            
            [array addObjectsFromArray:self.array];
            [cellHeightArray addObjectsFromArray:self.cellHeightArray];
            [cellMarkArray addObjectsFromArray:self.cellMarkArray];
            self.array = array;
            self.cellHeightArray = cellHeightArray;
            self.cellMarkArray = cellMarkArray;
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
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
