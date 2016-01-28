//
//  HTDetailStrategyCell.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/26.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTDetailStrategyModel;

@interface HTDetailStrategyCell : UITableViewCell
/**
 *  详情攻略主题
 */
@property (weak, nonatomic) IBOutlet UILabel *detailTopicLabel;
/**
 *  所在城市
 */
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
/**
 *  详情介绍
 */
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
/**
 *  攻略
 */
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
/**
 *  攻略model
 */
@property (strong, nonatomic) HTDetailStrategyModel *model;

/**
 *  计算文本的高度
 *
 *  @param model 需要计算的model
 *
 *  @return 标题高度与文本高度的集合
 */
+ (NSArray *)caculateHeightForLabelWithModel:(HTDetailStrategyModel *)model;
/**
 *  给cell的属性赋值
 *
 *  @param model                   存储属性值的model
 *  @param recordContentViewHeight cell中文本内容的高度
 */
- (void)setCellValueWithModel:(HTDetailStrategyModel *)model;

@end
