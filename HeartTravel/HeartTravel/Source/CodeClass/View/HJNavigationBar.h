//
//  HJNavigationBar.h
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJNavigationBar : UINavigationBar

@property (nonatomic,strong)UIView *bgView;
/**
 *   显示导航条背景颜色
 */
- (void)show;
/**
 *   隐藏
 */
- (void)hidden;

@end
