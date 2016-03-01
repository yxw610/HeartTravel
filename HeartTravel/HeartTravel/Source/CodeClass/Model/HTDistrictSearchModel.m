//
//  HTDistrictSearchModel.m
//  WriteRecord
//
//  Created by 杨晓伟 on 16/1/27.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTDistrictSearchModel.h"

@implementation HTDistrictSearchModel

/**
 *  重写：赋值时，如果key值不匹配时自动调用的方法
 *
 *  @param value value值
 *  @param key   未匹配的key
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
#warning 测试成功时，就可以去掉该打印
    //    NSLog(@"====%@",key);
}


#warning 测试成功时，就可以去掉
- (NSString *)description {
    
    return [NSString stringWithFormat:@"districtModel is %@",_name];
}

@end
