//
//  HTTravelRecordTableViewCell.m
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTTravelRecordTableViewCell.h"
#import "HTTravelRecordModel.h"
#import "HTUserModel.h"
#import "HTRecordContentModel.h"
#import "UIImageView+WebCache.h"
#import "HTPhotoContentCarouselFigureView.h"
#import "HTTravelRecordTableViewController.h"
#import "HTTravelRecordPhotoCarouselViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kRecordContentViewHeight (kScreenWidth * 3 / 8)

@interface HTTravelRecordTableViewCell ()

/**
 *  游记View
 */
@property (weak, nonatomic) IBOutlet UIView *recordContentView;

/**
 *  封面图片View的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicImgViewHeightConstraint;

/**
 *  游记View的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordContentViewHeightConstraint;

/**
 *  游记标题Label的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordTopicLabelHeightConstraint;

/**
 *  游记内容Label到父视图底部的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordContentLabelConstraintToRecordContentViewBottom;

@end

@implementation HTTravelRecordTableViewCell

- (void)awakeFromNib {
    
    // 用户头像切圆
    self.userImgView.layer.cornerRadius = self.userImgView.frame.size.height / 2;
    self.userImgView.layer.masksToBounds = YES;

}


/**
 *  给cell赋值方法
 *
 *  @param model model对象
 */
- (void)setCellValueWithModel:(HTTravelRecordModel *)model imgViewHeight:(CGFloat)imgViewHeight recordContentViewHeight:(CGFloat)recordContentViewHeight{
    
    self.model = model;
    
    // 设置用户信息
    self.userNameLabel.text = model.userInfo.name;
    [self.userImgView sd_setImageWithURL:[NSURL URLWithString:model.userInfo.photo_url]];
    
    // 设置图片信息
    self.topicImgViewHeightConstraint.constant = imgViewHeight;
    [self.topicImgView sd_setImageWithURL:[NSURL URLWithString:((HTRecordContentModel *)model.contents[0]).photo_url]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapActionInTopicImageView:)];
    self.topicImgView.userInteractionEnabled = YES;
    [self.topicImgView addGestureRecognizer:tap];
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:model.contents];
    [imageArray removeObjectAtIndex:0];
    
    if (self.carouselView.subviews) {
        
        for (HTPhotoContentCarouselFigureView *view in self.carouselView.subviews) {
            
            [view removeFromSuperview];
        }
    }

    
    [self drawScrollViewWithImages:imageArray];
    
    
    
    NSArray *heightArray = [HTTravelRecordTableViewCell caculateHeightForLabelWithModel:model];
    
    self.recordContentViewHeightConstraint.constant = recordContentViewHeight + 5;
    
    self.recordTopicLabelHeightConstraint.constant = [heightArray[0] floatValue];
    
    if (recordContentViewHeight != kRecordContentViewHeight) {
        
        self.recordContentLabelConstraintToRecordContentViewBottom.constant = 0;
    } else {
        
        self.recordContentLabelConstraintToRecordContentViewBottom.constant = 25;
    }
    
    self.recordTopicLabel.text = model.topic;
    self.recordContentLabel.text = model.desc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  显示全部文本
 *
 *  @param sender button
 */
- (IBAction)showWholeRecordAction:(id)sender {
    
    self.showWholeRecordBlock(self);
    
}

/**
 *  计算文本的高度
 *
 *  @param model 需要计算的model
 *
 *  @return 标题高度与文本高度的集合
 */
+ (NSArray *)caculateHeightForLabelWithModel:(HTTravelRecordModel *)model {
    
    NSMutableArray *heightArray = [NSMutableArray array];
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize topicSize = [model.topic boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 10000) options:option attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    if (topicSize.height <= 20) {
        topicSize.height = 20;
    } else {
        topicSize.height = 40;
    }
    [heightArray addObject:@(topicSize.height)];
    
    CGSize contentSize = [model.desc boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 10000) options:option attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    [heightArray addObject:@(contentSize.height)];
    
    CGFloat totalHeight = contentSize.height + topicSize.height;
    
    if (totalHeight > kRecordContentViewHeight - 25) {
        
        totalHeight = kRecordContentViewHeight;
    }
    
    [heightArray addObject:@(totalHeight)];
    
    return heightArray;
}

#define kGap 5
#define kImgViewHeight ((kScreenWidth / 4) - 2 * kGap)
#define kImgViewWidth (kImgViewHeight * 2)


- (void)drawScrollViewWithImages:(NSMutableArray *)images {
        
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.carouselView.bounds];
    
    scrollView.bounces = NO;
    scrollView.pagingEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake((kImgViewWidth + kGap) * images.count + kGap, kImgViewHeight + 2 * kGap);

    // 添加图片视图
    for (int i = 0; i < images.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kImgViewWidth * i + kGap * (i + 1), kGap, kImgViewWidth, kImgViewHeight)];
        
        HTRecordContentModel *model = images[i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:model.photo_url]];
        imgView.userInteractionEnabled = YES;
        imgView.tag = 1000 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapActionInImageView:)];
        [imgView addGestureRecognizer:tap];
        
        [scrollView addSubview:imgView];
    }
    
    [self.carouselView addSubview:scrollView];
}

#pragma mark -- Tap 手势 --
/**
 *  点击轮播图片
 *
 *  @param tap tap手势
 */
- (void)handleTapActionInImageView:(UITapGestureRecognizer *)tap {
    
    // 获取点击的视图
    UIImageView *imgView = (UIImageView *)tap.view;
    NSInteger index = imgView.tag - 1000;
    
    HTTravelRecordPhotoCarouselViewController *carouselViewController = [[HTTravelRecordPhotoCarouselViewController alloc] init];
    NSMutableArray *imgArray = [self.model.contents mutableCopy];
    carouselViewController.carouselView.defaultPage = index+1;
    carouselViewController.carouselView.images = imgArray;

    HTTravelRecordTableViewController *viewController = (HTTravelRecordTableViewController *)self.superview.superview.nextResponder;

    [viewController presentViewController:carouselViewController animated:YES completion:nil];
}

/**
 *  点击封面图片
 *
 *  @param tap tap手势
 */
- (void)handleTapActionInTopicImageView:(UITapGestureRecognizer *)tap {
    
    HTTravelRecordPhotoCarouselViewController *carouselViewController = [[HTTravelRecordPhotoCarouselViewController alloc] init];
    NSMutableArray *imgArray = [self.model.contents mutableCopy];
    carouselViewController.carouselView.defaultPage = 0;
    carouselViewController.carouselView.images = imgArray;
    
    HTTravelRecordTableViewController *viewController = (HTTravelRecordTableViewController *)self.superview.superview.nextResponder;
    
    [viewController presentViewController:carouselViewController animated:YES completion:nil];
}
@end
