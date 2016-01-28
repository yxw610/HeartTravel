//
//  HTDiscoveryHot.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTDiscoveryHot.h"

@implementation HTDiscoveryHot

// 重写的kvc部分方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@",_name];
}

@end
