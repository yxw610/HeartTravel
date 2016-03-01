//
//  HTFavoriteRecordTableViewController.m
//  HeartTravel
//
//  Created by 杨晓伟 on 16/3/1.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTFavoriteRecordTableViewController.h"
#import "HTTravelRecordModel.h"
#import <RESideMenu/RESideMenu.h>
#import <AVOSCloud.h>
#import "GetUser.h"

#define kFavoriteRecord @"FavoriteRecord"
#define kFavoriteInfo @"FavoriteInfo"

static NSString * const favoriteID = @"favoriteCellIdentifier";

@interface HTFavoriteRecordTableViewController ()

@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSArray *urlArray;
@property (strong, nonatomic) NSArray *localArray;

@end

@implementation HTFavoriteRecordTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {

        self.array = [NSMutableArray array];
        self.urlArray = [NSArray array];
        self.localArray = [NSArray array];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人收藏";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HTiconfont-fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    [self searchUrlArray];
    [self searchLocalArray];
    [self.array addObjectsFromArray:self.urlArray];
    [self.array addObjectsFromArray:self.localArray];
    [self.tableView reloadData];

    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:favoriteID];
    
}

- (void)searchUrlArray {
    
    AVQuery *query = [AVQuery queryWithClassName:kFavoriteRecord];
    GetUser *user = [GetUser shareGetUser];
    [query whereKey:@"user_id" equalTo:@(user.user_id)];
    self.urlArray = [query findObjects];
    
}

- (void)searchLocalArray {
    
    AVQuery *query = [AVQuery queryWithClassName:kFavoriteInfo];
    GetUser *user = [GetUser shareGetUser];
    [query whereKey:@"user_id" equalTo:@(user.user_id)];
    self.localArray = [query findObjects];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:favoriteID forIndexPath:indexPath];
//    if (cell == nil) {
//        
//        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:favoriteID];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < self.urlArray.count) {
        
        AVObject *object = self.array[indexPath.row];
        AVQuery *query = [AVQuery queryWithClassName:@"URLRecord"];
        [query whereKey:@"model_id" equalTo:object[@"model_id"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            AVObject *cellObject = [objects firstObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                cell.textLabel.text = cellObject[@"topic"];

            });
        }];
    } else {
        
        AVObject *object = self.array[indexPath.row];
        AVQuery *query = [AVQuery queryWithClassName:@"TravelRecord"];
        [query whereKey:@"model_id" equalTo:object[@"model_id"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            AVObject *cellObject = [objects firstObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                cell.textLabel.text = cellObject[@"topic"];

            });
        }];
    }
    
    return cell;
    
}


// 返回左边菜单栏
- (void)backAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
