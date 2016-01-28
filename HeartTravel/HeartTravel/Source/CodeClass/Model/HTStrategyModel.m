//
//  HTStrategyModel.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTStrategyModel.h"
#import "HTStrategyPhoto.h"

@implementation HTStrategyModel

/**
 *  重写：赋值时，如果key值不匹配时自动调用的方法
 *
 *  @param value value值
 *  @param key   未匹配的key
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        [self setValue:value forKey:@"strategy_id"];
    }
//    if ([key isEqualToString:@"photo"]) {
//        HTStrategyPhoto *model = [HTStrategyPhoto new];
//        [model setValuesForKeysWithDictionary:(NSDictionary *)value];
//        
//        [self setValue:model forKey:@"photoInfo"];
//    }
}
- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"photo"]) {
        self.photo = [HTStrategyPhoto new];
        [self.photo setValuesForKeysWithDictionary:(NSDictionary *)value];
    }
}

@end
