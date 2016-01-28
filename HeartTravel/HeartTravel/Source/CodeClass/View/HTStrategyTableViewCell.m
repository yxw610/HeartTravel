//
//  HTStrategyTableViewCell.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTStrategyTableViewCell.h"
#import "HTStrategyModel.h"
#import "HTStrategyPhoto.h"
#import <UIImageView+WebCache.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface HTStrategyTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *strategyImgViewHeightConstraints;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeightConstraints;


@end

@implementation HTStrategyTableViewCell

/**
 *  给cell的属性赋值
 *
 *  @param mdoel              存储属性值得model
 *  @param imgViewHeight      cell中图片视图的高度
 *  @param contentLabelHeight cell中攻略内容的高度
 */
- (void)setCellValueWithModel:(HTStrategyModel *)model ImgViewHeight:(CGFloat)imgViewHeight contentLabelHeight:(CGFloat)contentLabelHeight {
    self.model = model;
    
    //设置图片信息
    self.strategyImgViewHeightConstraints.constant = imgViewHeight;
    [self.strategyImgView sd_setImageWithURL:[NSURL URLWithString:model.photo.photo_url]];
    //设置内容
    
    self.contentLabelHeightConstraints.constant = contentLabelHeight+10;
    self.contentLabel.text = model.introduce;
    
}

/**
 *  计算文本高度
 *
 *  @param model 需要计算的model
 *
 *  @return 返回文本高度
 */
+ (CGFloat)caculateHeightForLabelWithModel:(HTStrategyModel *)model {
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    
    CGSize contentSize = [model.introduce boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 10000) options:option attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    CGFloat contentHeight = contentSize.height;
    
    return contentHeight;
}
/**
 *  按钮事件
 *
 *  @param sender 指代按钮
 */
- (IBAction)detailAction:(id)sender {
    if (nil != _delegate && [_delegate respondsToSelector:@selector(moreDetailClick:)]) {
        [self.delegate moreDetailClick:self];
    }
}

- (void)awakeFromNib {
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
