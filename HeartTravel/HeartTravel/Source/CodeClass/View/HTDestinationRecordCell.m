//
//  HTDestinationRecordCell.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/20.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTDestinationRecordCell.h"
#import "HTTravelRecordModel.h"
#import "HTUserModel.h"
#import "HTRecordContentModel.h"
#import "UIImageView+WebCache.h"
#import "HTPhotoContentCarouselFigureView.h"
#import "HTDestinationStrategyController.h"
#import "HTTravelRecordPhotoCarouselViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kRecordContentViewHeight (kScreenWidth * 3 / 8)
@interface HTDestinationRecordCell ()

/**
 *  游记View
 */
@property (weak, nonatomic) IBOutlet UIView *recordContentView;
/**
 *  游记View的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordContentViewHeightConstraint;
/**
 *  封面图片View的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicImgViewHeightConstraint;
/**
 *  游记标题Label的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordTopicLabelHeightConstraint;
/**
 *  游记内容Label到父视图底部的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordContentLabelConstraintToRecordContentViewButtom;

@end

@implementation HTDestinationRecordCell

/**
 *  给cell赋值方法
 *
 *  @param model model对象
 */
- (void)setCellValueWithModel:(HTTravelRecordModel *)model imgViewHeight:(CGFloat)imgViewHeight recordContentViewHeight:(CGFloat)recordContentViewHeight{
    
    self.model = model;
    // 设置用户信息
    self.userNameLabel.text = model.userInfo.name;
    // 设置图片信息
    self.topicImgViewHeightConstraint.constant = imgViewHeight;
    [self.recordImageView sd_setImageWithURL:[NSURL URLWithString:((HTRecordContentModel *)model.contents[0]).photo_url]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapActionInTopicImageView:)];
    self.recordImageView.userInteractionEnabled = YES;
    [self.recordImageView addGestureRecognizer:tap];

    NSArray *heightArray = [HTDestinationRecordCell caculateHeightForLabelWithModel:model];
    
    self.recordContentViewHeightConstraint.constant = recordContentViewHeight + 5;
    
    self.recordTopicLabelHeightConstraint.constant = [heightArray[0] floatValue];
    
    if (recordContentViewHeight != kRecordContentViewHeight) {
        
        self.recordContentLabelConstraintToRecordContentViewButtom.constant = 0;
        self.wholeContentButton.hidden = YES;
    } else {
        
        self.recordContentLabelConstraintToRecordContentViewButtom.constant = 25;
    }
    
    self.recordTopicLabel.text = model.topic;
    self.recordContentLabel.text = model.desc;
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
    CGSize topicSize = [model.topic boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 10000) options:option attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    if (topicSize.height <= 20) {
        topicSize.height = 20;
    } else {
        topicSize.height = 40;
    }
    [heightArray addObject:@(topicSize.height)];
    
    CGSize contentSize = [model.desc boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 10000) options:option attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    [heightArray addObject:@(contentSize.height)];
    
    CGFloat totalHeight = contentSize.height + topicSize.height;
    
    if (totalHeight > kRecordContentViewHeight - 25) {
        
        totalHeight = kRecordContentViewHeight;
    }
    
    [heightArray addObject:@(totalHeight)];
    
    return heightArray;
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
    
    HTDestinationStrategyController *viewController = (HTDestinationStrategyController *)self.superview.superview.nextResponder;
    
    [viewController presentViewController:carouselViewController animated:YES completion:nil];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
