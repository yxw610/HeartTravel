//
//  HTCityDetailsModel.m
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/19.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTCityDetailsModel.h"

@implementation HTCityDetailsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@",self.name_cn];
}

@end
