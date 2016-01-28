//
//  HTCollectionReusableView.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTCollectionReusableView.h"

@implementation HTCollectionReusableView

// 初始化增补视图的标题
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
