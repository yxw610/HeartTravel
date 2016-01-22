//
//  YHCarouselFigureView.m
//  LessonCarouselFigureView
//
//  Created by 杨晓伟 on 15/12/12.
//  Copyright © 2015年 杨晓伟. All rights reserved.
//

#import "HTPhotoContentCarouselFigureView.h"
#import "UIImageView+WebCache.h"
#import "HTRecordContentModel.h"

// 当前视图的宽度
#define kScreenWidth self.bounds.size.width

// 当前视图的高度
#define kScreenHeight self.bounds.size.height

// 当前图片的个数
#define kCount self.images.count


@interface HTPhotoContentCarouselFigureView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIPageControl *pageControl;


@end


@implementation HTPhotoContentCarouselFigureView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hasPageControl = NO;
        self.imgViewWidth = kScreenWidth;
        self.imgViewHeight = kScreenHeight;
        self.pageScroll = NO;
        self.gap = 0;
        self.defaultPage = 0;
    }
   
    return self;
}

#warning 如果没用了就删除掉
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.hasPageControl = NO;
        self.imgViewWidth = kScreenWidth;
        self.imgViewHeight = kScreenHeight;
        self.pageScroll = NO;
        self.gap = 0;
        self.defaultPage = 0;
    }
    
    return self;
}

/**
 *  images的setter，当对图片数组赋值时触发
 *
 *  @param images 图片数据
 */

- (void)setImages:(NSArray *)images {
    
    if (_images != images) {
        
        _images = nil;
        _images = images;
    }
    
    if (_scrollView.subviews != nil) {
        
        _scrollView = nil;
    }
    
    // 在外界对图片数组赋值的时候，开始绘图
    [self drawView];
    
}


// 绘制视图的方法
- (void)drawView {
    [self addSubview:self.scrollView];
    if (self.isHasPageControl == YES) {
        
        [self addSubview:self.pageControl];
    }
}

// 懒加载ScrollView
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
  
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = self.isPageScroll;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake((self.imgViewWidth + self.gap) * kCount + self.gap, self.imgViewHeight + 2 * self.gap);
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(self.imgViewWidth * self.defaultPage, 0);
        
        // 添加图片视图
        for (int i = 0; i < kCount; i++) {
            
            HTRecordContentModel *model = self.images[i];
            
            CGFloat imgHeight = self.imgViewWidth * model.height / model.width;
            
            if (imgHeight > self.imgViewHeight) {
                
                imgHeight = self.imgViewHeight;
            }
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.imgViewWidth * i + self.gap * (i + 1), self.gap, self.imgViewWidth, imgHeight)];
            imgView.center = CGPointMake(imgView.center.x, self.imgViewHeight / 2);
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:model.photo_url]];
            imgView.userInteractionEnabled = YES;
            imgView.tag = 1000 + i;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapActionInImageView:)];
            [imgView addGestureRecognizer:tap];
            
            [_scrollView addSubview:imgView];
            
            NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
            CGFloat labelHeight = [model.caption boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 10000) options:option attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.imgViewWidth * i + self.gap * (i + 1) + 5, kScreenHeight - labelHeight, self.imgViewWidth - 10, labelHeight)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.text = model.caption;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor colorWithRed:63.1 / 255.0 green:63.1 / 255.0 blue:63.1 / 255.0 alpha:0.7];
            [_scrollView addSubview:label];
        }
    }
    
    return _scrollView;
}

#define kGap 10
#define kPageControlHeight 29

// 懒加载PageControl
- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.imgViewWidth, kPageControlHeight)];
        _pageControl.center = CGPointMake(self.imgViewWidth / 2, kGap + kPageControlHeight / 2);
        _pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.numberOfPages = self.images.count;
        _pageControl.currentPage = self.defaultPage;
    }
    
    return _pageControl;
}

#pragma mark -- UIScrollViewDeleage --

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 根据视图偏移校正当前下标
    self.currentIndex = scrollView.contentOffset.x / kScreenWidth;
    
    if (self.isHasPageControl == YES) {
        // 根据新的下标校正pageControl的currentPage
        self.pageControl.currentPage = self.currentIndex;
    }
}

#pragma mark -- Tap 手势 --

- (void)handleTapActionInImageView:(UITapGestureRecognizer *)tap {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(tapImageView)]) {
        
        [_delegate performSelector:@selector(tapImageView)];
    }
}


@end
