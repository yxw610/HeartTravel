//
//  YHCarouselFigureView.h
//  LessonCarouselFigureView
//
//  Created by 杨晓伟 on 15/12/12.
//  Copyright © 2015年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTPhotoContentCarouselFigureViewDelegate <NSObject>

- (void)tapImageView;

@end

@interface HTPhotoContentCarouselFigureView : UIView 

/**
 *  图片数组，外界赋值轮播图片的时候使用，或者获取轮播图片时使用
 */
@property (strong, nonatomic) NSArray *images;

/**
 * 当前下标
 */
@property (assign, nonatomic) NSUInteger currentIndex;

/**
 *  设置是否有pageControl,default is NO
 */
@property (assign, nonatomic, getter=isHasPageControl) BOOL hasPageControl;

/**
 *  设置图片的宽度,默认为屏幕宽度
 */
@property (assign, nonatomic) CGFloat imgViewWidth;

/**
 *  设置图片的高度,默认为屏幕高度
 */
@property (assign, nonatomic) CGFloat imgViewHeight;

/**
 *  设置是否整页翻动,默认为NO
 */
@property (assign, nonatomic, getter=isPageScroll) BOOL pageScroll;

/**
 *  设置图片的间隔,默认为0
 */
@property (assign, nonatomic) CGFloat gap;

/**
 *  设置默认显示页面
 */
@property (assign, nonatomic) NSInteger defaultPage;

@property (strong, nonatomic) id<HTPhotoContentCarouselFigureViewDelegate> delegate;

@end
