//
//  HTTrabelRecordModel.m
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTTravelRecordModel.h"
#import "HTUserModel.h"
#import "HTCategoryModel.h"
#import "HTRecordContentModel.h"
#import "HTDistrictModel.h"

@implementation HTTravelRecordModel

/**
 *  重写：赋值时，如果key值不匹配时自动调用的方法
 *
 *  @param value value值
 *  @param key   未匹配的key
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"description"]) {
        
        [self setValue:value forKey:@"desc"];
    }
    
    if ([key isEqualToString:@"id"]) {
        
        [self setValue:value forKey:@"model_id"];
    }
    
    if ([key isEqualToString:@"user"]) {
        
        HTUserModel *model = [HTUserModel new];
        [model setValuesForKeysWithDictionary:(NSDictionary *)value];
        
        [self setValue:model forKey:@"userInfo"];
    }
#warning 测试成功时，就可以去掉该打印
//    NSLog(@"====%@",key);
}

/**
 *  重写该方法，目的是将model中的几个数组属性中存放相应的model
 *
 *  @param value value值
 *  @param key   key
 */
- (void)setValue:(id)value forKey:(NSString *)key {
    
    // 调用父类的方法
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"categories"]) {
        
        NSArray *categoriesArray = value;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in categoriesArray) {
            
            HTCategoryModel *model = [HTCategoryModel new];
            
            [model setValuesForKeysWithDictionary:dict];
            
            [tempArray addObject:model];
        }
        _categories = tempArray;
    }
    
    if ([key isEqualToString:@"contents"]) {
        
        NSArray *contentsArray = value;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in contentsArray) {
            
            HTRecordContentModel *model = [HTRecordContentModel new];
            
            [model setValuesForKeysWithDictionary:dict];
            
            [tempArray addObject:model];
        }
        _contents = tempArray;
    }
    
    if ([key isEqualToString:@"districts"]) {
        
        NSArray *districtsArray = value;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in districtsArray) {
            
            HTDistrictModel *model = [HTDistrictModel new];
            
            [model setValuesForKeysWithDictionary:dict];
            
            [tempArray addObject:model];
        }
        _districts = tempArray;
    }
    
}

#warning 测试成功时，就可以去掉
- (NSString *)description {
    
    return [NSString stringWithFormat:@"TravelRecordModel is %@",_topic];
}

@end
