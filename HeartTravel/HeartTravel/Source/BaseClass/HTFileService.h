//
//  HTFileService.h
//  HeartTravel
//
//  Created by 杨晓伟 on 16/3/2.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTFileService : NSObject

+(float)folderSizeAtPath:(NSString *)path;

+(void)clearCache:(NSString *)path;

@end
