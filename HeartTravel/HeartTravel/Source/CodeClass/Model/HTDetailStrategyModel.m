//
//  HTDetailStrategyModel.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/26.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTDetailStrategyModel.h"
#import "HTStrategyPhoto.h"
#import "HTDistrictModel.h"

@implementation HTDetailStrategyModel
/**
 *  重写：赋值时，如果key值不匹配时自动调用的方法
 *
 *  @param value value值
 *  @param key   未匹配的key
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        [self setValue:value forKey:@"detail_id"];
    }
}
- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"photo"]) {
        self.photo = [HTStrategyPhoto new];
        [self.photo setValuesForKeysWithDictionary:(NSDictionary *)value];
    }
    if ([key isEqualToString:@"district"]) {
        self.district = [HTDistrictModel new];
        [self.district setValuesForKeysWithDictionary:(NSDictionary *)value];
    }
}

@end
