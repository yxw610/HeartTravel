//
//  HTDiscoveryDetail.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDestinationStrategy : NSObject
/**
 *  城市名ID(实际id)
 */
@property (strong, nonatomic)NSString *ID;
/**
 *  旅行灵感数
 */
@property (assign, nonatomic)NSInteger inspiration_activities_count;
/**
 *  城市名
 */
@property (strong, nonatomic)NSString *name;
/**
 *  图片
 */
@property (strong, nonatomic)NSString *photo_url; 

@end
