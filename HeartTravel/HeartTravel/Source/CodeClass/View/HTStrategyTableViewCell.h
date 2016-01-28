//
//  HTStrategyTableViewCell.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTStrategyModel;
/**
 *  创建一个页面跳转代理
 */
@protocol moreDetailDelegate <NSObject>

- (void)moreDetailClick:(UITableViewCell *)cell;

@end

@interface HTStrategyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *strategyImgView;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  攻略model
 */
@property (strong, nonatomic) HTStrategyModel *model;
/**
 *  计算文本高度
 *
 *  @param model 需要计算的model
 *
 *  @return 返回文本高度
 */
+ (CGFloat)caculateHeightForLabelWithModel:(HTStrategyModel *)model;
/**
 *  给cell的属性赋值
 *
 *  @param mdoel              存储属性值得model
 *  @param imgViewHeight      cell中图片视图的高度
 *  @param contentLabelHeight cell中攻略内容的高度
 */
- (void)setCellValueWithModel:(HTStrategyModel *)model ImgViewHeight:(CGFloat)imgViewHeight contentLabelHeight:(CGFloat)contentLabelHeight;
/**
 *  创建代理属性
 */
@property (assign, nonatomic)id<moreDetailDelegate>delegate;


@end
