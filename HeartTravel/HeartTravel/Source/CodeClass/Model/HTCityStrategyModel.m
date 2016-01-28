//
//  HTCityStrategyModel.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTCityStrategyModel.h"

@implementation HTCityStrategyModel
/**
 *  重写：赋值时，如果key值不匹配时自动调用的方法
 *
 *  @param value value值
 *  @param key   未匹配的key
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.city_id = [NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"description"]) {
        self.descripe = [NSString stringWithFormat:@"%@",value];
    }
}

@end
