//
//  iCarouselExampleViewController.h
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//  轮播图:各种各样的cover flow效果.
//  是一个用来简化在 iOS 上实现旋转木马时的视图切换效果，支持 iPad，提供多种切换效果。内容类似的页面需要并排列出来，供用户选择。iCarousel具有非常酷的3D效果，比如经典的CoverFlow, TimeMachine。另外还具有线性，圆柱状等其它效果。可用于图片选择，书籍选择，网页选择等。

#import <UIKit/UIKit.h>
@class iCarousel;

@interface HTWorldExploreViewController : UIViewController

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;

@end
