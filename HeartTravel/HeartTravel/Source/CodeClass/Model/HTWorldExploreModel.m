//
//  HTWorldExploreModel.m
//  Test1
//
//  Created by 马浩杰 on 16/1/16.
//  Copyright © 2016年 MHJ. All rights reserved.
//

#import "HTWorldExploreModel.h"

@implementation HTWorldExploreModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
    
}


- (NSString *)description {
    
    
    return [NSString stringWithFormat:@"%@",self.name_cn];
}



@end
