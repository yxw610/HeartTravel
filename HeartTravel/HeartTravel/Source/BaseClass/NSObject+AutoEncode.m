//
//  NSObject+AutoEncode.m
//  FXRuntime_AutoEncode
//
//  Created by 杨晓伟 on 16/2/29.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "NSObject+AutoEncode.h"
#import <objc/runtime.h>

@implementation NSObject (AutoEncode)

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    // 拿到当前self中，所有成员变量
    unsigned int iVarCount = 0;
    
    Ivar *ivars = class_copyIvarList([self class], &iVarCount);
    
    for (int i = 0; i < iVarCount; i++) {
        
        // key
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
        
        // 值
        id varValue = [self valueForKey:varName];
        
        // 编码
        [aCoder encodeObject:varValue forKey:varName];
    }
    
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [self init]) {
        
        // 拿到当前self中，所有成员变量
        unsigned int iVarCount = 0;
        
        Ivar *ivars = class_copyIvarList([self class], &iVarCount);
        
        for (int i = 0; i < iVarCount; i++) {
            // key
            NSString *varName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
            
            // 根据key反编码得到value
            id varValue = [aDecoder decodeObjectForKey:varName];
            
            // 设置self的key和value
            [self setValue:varValue forKey:varName];
        }
        
        free(ivars);
    }
    
    return self;
}

@end
