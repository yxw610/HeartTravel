//
//  HTDestinationRecordCell.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/20.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTravelRecordModel;

@interface HTDestinationRecordCell : UITableViewCell

/**
 *  展开更多文本信息
 */
@property (copy, nonatomic) void(^showWholeRecordBlock)(HTDestinationRecordCell *currentCell);
/**
 *  游记标题
 */
@property (weak, nonatomic) IBOutlet UILabel *recordTopicLabel;
/**
 *  游记内容
 */
@property (weak, nonatomic) IBOutlet UILabel *recordContentLabel;
/**
 *  封面图片
 */

@property (weak, nonatomic) IBOutlet UIImageView *recordImageView;
/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/**
 *  阅读全文按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *wholeContentButton;

/**
 *  游记model
 */
@property (strong, nonatomic) HTTravelRecordModel *model;

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
