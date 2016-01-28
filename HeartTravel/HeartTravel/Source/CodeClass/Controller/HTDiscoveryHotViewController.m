//
//  HTDiscoveryHotViewController.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTDiscoveryHotViewController.h"
#import "HTDiscoveryHotCell.h"
#import "HTDiscoveryHot.h"
#import "GetDataTools.h"
#import <AFNetworking.h>
#import "HTCollectionReusableView.h"
#import "HTDestinationStrategyController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define Hot_URL @"http://q.chanyouji.com/api/v1/search/featured.json"

@interface HTDiscoveryHotViewController ()<UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic)NSMutableArray *dataArray;

@end

@implementation HTDiscoveryHotViewController
// cell重用标识符
static NSString * const reuseIdentifier = @"Cell";
// 增补视图header重用标识符
static NSString * const cellReuseIdentifier = @"cellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"HTDiscoveryHotCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    // 注册增补视图
    //header
    [self.collectionView registerClass:[HTCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellReuseIdentifier];
    
    [self drawView];
}
- (void)drawView {
    [[GetDataTools shareGetDataTools] getDataWithUrlString:Hot_URL data:^(NSDictionary *dataDict) {
        self.dataArray = [[NSMutableArray alloc] initWithCapacity:15];
        for (NSDictionary *dict in dataDict[@"data"][@"destinations"]) {
            HTDiscoveryHot *model = [HTDiscoveryHot new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        // 返回主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });

    }];
//    /**
//     *  使用AFNetWorking进行网络解析
//     */
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:Hot_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        self.dataArray = [[NSMutableArray alloc] initWithCapacity:15];
//        for (NSDictionary *dict in ((NSDictionary *)responseObject)[@"data"][@"destinations"]) {
//            HTDiscoveryHot *model = [HTDiscoveryHot new];
//            [model setValuesForKeysWithDictionary:dict];
//            [self.dataArray addObject:model];
//        }
//        // 返回主线程刷新
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.collectionView reloadData];
//        });
//    } failure:nil];
    
}
// 返回增补视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    // 从重用池里面取出来
    HTCollectionReusableView *headerReuseView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    // 设置文本
    headerReuseView.titleLabel.text = @"热门目的地";
    return headerReuseView;
}
// 设置header区域大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(10, 25);
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
// 设置边缘距离 上左下右
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 15, 10, 15);
}
// 设置item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/7*2, kScreenWidth/8*3);
}
// 设置最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
// 设置最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTDiscoveryHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    HTDiscoveryHot *model = self.dataArray[indexPath.item];
    cell.discoveryHot = model;
    return cell;
}
// 点击item触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HTDiscoveryHot *model = self.dataArray[indexPath.item];
    HTDestinationStrategyController *detailVC = [[HTDestinationStrategyController alloc] initWithStyle:(UITableViewStyleGrouped)];
    detailVC.stringID = model.ID;
    detailVC.string = model.name;
    [self.navigationController pushViewController:detailVC animated:YES];
}
// 返回collectionView相关路径是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
