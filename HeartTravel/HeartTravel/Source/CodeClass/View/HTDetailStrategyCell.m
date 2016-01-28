//
//  HTDetailStrategyCell.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/26.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTDetailStrategyCell.h"
#import "HTDetailStrategyModel.h"
#import "HTDistrictModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kRecordContentViewHeight (kScreenWidth * 3 / 8)
@interface HTDetailStrategyCell ()
/**
 *  详情介绍高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceConstraint;
/**
 *  攻略高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabelConstraint;

@end
@implementation HTDetailStrategyCell

/**
 *  给cell的属性赋值
 *
 *  @param model                   存储属性值的model
 *  @param recordContentViewHeight cell中文本内容的高度
 */
- (void)setCellValueWithModel:(HTDetailStrategyModel *)model {
    self.model = model;
    // 设置攻略主题
    self.detailTopicLabel.text = model.topic;
    // 设置所在城市
    self.cityNameLabel.text = model.district.name;
    NSArray *heightArray = [HTDetailStrategyCell caculateHeightForLabelWithModel:model];
    // 设置攻略详情介绍
    self.introduceLabel.text = model.introduce;
    self.introduceConstraint.constant = [heightArray[0] floatValue]+5;
    // 设置旅游攻略
    self.tipLabel.text = model.tip;
    self.tipLabelConstraint.constant = [heightArray[1] floatValue]+10;
    
}
/**
 *  计算文本的高度
 *
 *  @param model 需要计算的model
 *
 *  @return 标题高度与文本高度的集合
 */
+ (NSArray *)caculateHeightForLabelWithModel:(HTDetailStrategyModel *)model {
    NSMutableArray *heightArray = [NSMutableArray array];
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize contentSize = [model.introduce boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 10000) options:option attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
      [heightArray addObject:@(contentSize.height)];
    CGSize tipSize = [model.tip boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 10000) options:option attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    [heightArray addObject:@(tipSize.height)];
    CGFloat totalHeight = contentSize.height + tipSize.height+15;
    [heightArray addObject:@(totalHeight)];
    
    return heightArray;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
