//
//  HTStrategyPhoto.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTStrategyPhoto : NSObject
/**
 *  图片高度
 */
@property (assign, nonatomic)NSInteger height;
/**
 *  图片url
 */
@property (strong, nonatomic)NSString *photo_url;
/**
 *  图片宽度
 */
@property (assign, nonatomic)NSInteger width;

@end
