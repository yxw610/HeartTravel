//
//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//  

#import "HTWorldExploreViewController.h"
#import "HTWorldExploreModel.h"
#import <UIImageView+WebCache.h>
#import <FXBlurView.h>
#import "UIView+WLFrame.h"
#import "MXPullDownMenu.h"
#import "HTCityTableViewController.h"
#import "HTCityModel.h"
#define WORD_URL @"http://www.koubeilvxing.com/countrys"

@interface HTWorldExploreViewController ()<MXPullDownMenuDelegate>
//定义一个属性开关来决定是否无限滑动
@property (nonatomic, assign) BOOL wrap;
//定义一个可变数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSArray *continentArray;

@end

@implementation HTWorldExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = [NSMutableArray array];
    self.continentArray = [NSArray array];
    self.continentArray = @[ @[@"亚洲",@"欧洲",@"北美洲",@"南美洲",@"非洲",@"大洋洲"]];
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:self.continentArray selectedColor:[UIColor greenColor]];
    menu.delegate = self;
    menu.frame = CGRectMake(0, 20, kScreenWidth, 44);
    [self.view addSubview:menu];
    //滑动图片样式
    self.carousel.type = iCarouselTypeRotary;
    self.wrap = YES;
    //数据解析
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:WORD_URL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        for (NSDictionary *dictionary in dataDict[@"continents"]) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dict in dictionary[@"countrys"]) {
                HTWorldExploreModel *model = [HTWorldExploreModel new];
                [model setValuesForKeysWithDictionary:dict];
                [tempArray addObject:model];
            }
            [self.dataArray addObject:tempArray];
        }
        self.dataArr = [NSMutableArray array];
        self.dataArr = self.dataArray[0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.carousel reloadData];
        });
    }];
    [dataTask resume];
}

//设置代理
- (void)dealloc {
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.dataArr.count;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.carousel = nil;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil) {
        view.contentMode = UIViewContentModeCenter;
        view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 300, 300)];
        view.backgroundColor = [UIColor yellowColor];
    }
    if (view.subviews.count != 0) {
        for (UIView *subView in view.subviews) {
            [subView removeFromSuperview];
        }
    }
    UIImageView *imgView = nil;
    imgView = [[UIImageView alloc] initWithFrame:view.bounds];
   
    HTWorldExploreModel *model = self.dataArr[index];

    NSString *str = [NSString stringWithFormat:@"http://img.koubeilvxing.com/pics%@",model.path];
    [imgView sd_setImageWithURL:[NSURL URLWithString:str]];
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
    [imgView addGestureRecognizer:singleTap];//点击图片事件

    UILabel *label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.left ,imgView.bottom , imgView.width, 50)];
    label.text = model.name_cn;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [imgView addSubview:label];
    imgView.tag = 1000 + index;
    [view addSubview:imgView];
    return view;
}

- (void)photoTapped:(UITapGestureRecognizer *)tap {
    
    UIImageView *imageView = (UIImageView *)tap.view;
    NSInteger index = imageView.tag - 1000;
    
    HTCityTableViewController *cityTVC = [HTCityTableViewController new];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:cityTVC];
    HTWorldExploreModel *model = self.dataArr[index];
    cityTVC.ID = model.ID;
    cityTVC.titleName = model.name_cn;
    [self presentViewController:navC animated:YES completion:nil];
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return self.wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    self.dataArr = self.dataArray[row];
    [self.carousel reloadData];
    self.carousel.scrollOffset = 0;

}


@end
