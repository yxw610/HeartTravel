//
//  HTNavigationBar.h
//  WriteRecord
//
//  Created by 杨晓伟 on 16/1/22.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTNavigationBar : UINavigationBar

/**
 *  标题栏
 */
@property (strong, nonatomic) UILabel *titleLabel;


/**
 * 设置允许变色的最大范围,默认为导航栏的高度
 */
@property (assign, nonatomic) CGFloat maxOffSet;

/**
 *  设置允许变色的最小范围,默认为0
 */
@property (assign, nonatomic) CGFloat minOffSet;

@property (strong, nonatomic) UIView *barColorView;

/**
 *  根据页面的偏移量来改变颜色
 *
 *  @param offSet 页面的偏移量
 *  @param color 导航栏颜色
 */
- (void)changeColorWithOffset:(CGFloat)offSet color:(UIColor *)color;

@end
