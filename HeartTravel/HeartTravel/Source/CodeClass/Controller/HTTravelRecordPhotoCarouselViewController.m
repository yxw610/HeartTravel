//
//  HTTravelRecordPhotoCarouselViewController.m
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/18.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTTravelRecordPhotoCarouselViewController.h"
#import "HTPhotoContentCarouselFigureView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HTTravelRecordPhotoCarouselViewController () <HTPhotoContentCarouselFigureViewDelegate>



@end

@implementation HTTravelRecordPhotoCarouselViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.carouselView];
}

- (HTPhotoContentCarouselFigureView *)carouselView {
        
    if (_carouselView == nil) {
        _carouselView = [[HTPhotoContentCarouselFigureView alloc] initWithFrame:self.view.bounds];
        _carouselView.delegate = self;
        _carouselView.hasPageControl = YES;
        _carouselView.pageScroll = YES;
        _carouselView.defaultPage= self.defaultPage;
    }
    return _carouselView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 实现代理方法
- (void)tapImageView {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
