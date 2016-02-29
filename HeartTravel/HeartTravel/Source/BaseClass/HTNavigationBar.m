//
//  HTNavigationBar.m
//  WriteRecord
//
//  Created by 杨晓伟 on 16/1/22.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTNavigationBar.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation HTNavigationBar

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        // 将NavigationBar上的_UINavigationVarBackground覆盖层移除掉
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                [view removeFromSuperview];
            }
        }
        
        // 判断设备的系统版本
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
        {
            self.frame=CGRectMake(0, 0, kScreenWidth, 64);
            self.maxOffSet = 64;
            
        }else{
            self.frame=CGRectMake(0, 0, kScreenWidth, 44);
            self.maxOffSet = 44;
        }
        
        self.minOffSet = 0;
        
        self.backgroundColor = [UIColor clearColor];

        self.barColorView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.bounds.size.width, self.bounds.size.height)];
        
        self.barColorView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.barColorView];
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                [view removeFromSuperview];
            }
        }
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
        {
            self.frame=CGRectMake(0, 0, kScreenWidth, 64);
            self.maxOffSet = 64;
            
        }else{
            self.frame=CGRectMake(0, 0, kScreenWidth, 44);
            self.maxOffSet = 44;
        }
        self.minOffSet = 0;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.barColorView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.bounds.size.width, self.bounds.size.height)];
        
        self.barColorView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.barColorView];
    }
    
    return self;
}

- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 4, 20, self.frame.size.width/2, self.frame.size.height - 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.barColorView addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

/**
 *  根据页面的偏移量来改变颜色
 *
 *  @param offSet 页面的偏移量
 */
- (void)changeColorWithOffset:(CGFloat)offSet color:(UIColor *)color{
    
    if (offSet <= -self.maxOffSet) {
        self.barColorView.backgroundColor = [color colorWithAlphaComponent:0];
    } else if (offSet >= -self.maxOffSet && offSet <= self.minOffSet) {
        
        CGFloat alpha;
        if (self.minOffSet >= self.maxOffSet) {
            
            alpha = 1.0;
        } else {
            
            alpha = (self.maxOffSet + offSet) / (self.maxOffSet - self.minOffSet);
        }

        self.barColorView.backgroundColor = [color colorWithAlphaComponent:alpha];

    } else {

        self.barColorView.backgroundColor = [color colorWithAlphaComponent:1];
    }
}
@end
