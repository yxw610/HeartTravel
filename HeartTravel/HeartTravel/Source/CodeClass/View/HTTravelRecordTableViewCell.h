//
//  HTTravelRecordTableViewCell.h
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTravelRecordModel;

@interface HTTravelRecordTableViewCell : UITableViewCell

/**
 *  展开更多文本信息
 */
@property (copy, nonatomic) void(^showWholeRecordBlock)(HTTravelRecordTableViewCell *currentCell);

/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;

/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

/**
 *  封面图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *topicImgView;

/**
 *  放置剩余图片的轮播图
 */
@property (weak, nonatomic) IBOutlet UIView *carouselView;

/**
 *  游记标题
 */
@property (weak, nonatomic) IBOutlet UILabel *recordTopicLabel;

/**
 *  游记内容
 */
@property (weak, nonatomic) IBOutlet UILabel *recordContentLabel;

/**
 *  阅读全文按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *wholeContentButton;

/**
 *  放置标签的轮播图
 */
@property (weak, nonatomic) IBOutlet UIView *markCarouselView;

/**
 *  游记model
 */
@property (strong, nonatomic) HTTravelRecordModel *model;

/**
 *  地区
 */
@property (weak, nonatomic) IBOutlet UILabel *districts;

/**
 *  喜爱
 */
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImgView;

/**
 *  喜爱人数
 */
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

/**
 *  计算文本的高度
 *
 *  @param model 需要计算的model
 *
 *  @return 标题高度与文本高度的集合
 */
+ (NSArray *)caculateHeightForLabelWithModel:(HTTravelRecordModel *)model;

/**
 *  给cell的属性赋值
 *
 *  @param model                   存储属性值的model
 *  @param imgViewHeight           cell中图片视图的高度
 *  @param recordContentViewHeight cell游记视图的高度
 */
- (void)setCellValueWithModel:(HTTravelRecordModel *)model imgViewHeight:(CGFloat)imgViewHeight recordContentViewHeight:(CGFloat)recordContentViewHeight;

@end
