//
//  HJNavigationBar.m
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HJNavigationBar.h"

@implementation HJNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self=[super initWithFrame:frame]) {
        
        for (UIView *view in  self.subviews) {
            
            if([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
                self.bgView = view;
        }
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.hidden = NO;
    }];
}

- (void)hidden {
    self.bgView.hidden = YES;
}

@end
