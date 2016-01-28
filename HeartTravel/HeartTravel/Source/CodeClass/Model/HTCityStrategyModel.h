//
//  HTCityStrategyModel.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCityStrategyModel : NSObject

/**
 *   攻略类型ID
 */
@property (strong, nonatomic)NSString *city_id;
/**
 *  内容
 */
@property (strong, nonatomic)NSString *descripe;
/**
 *  旅行灵感数
 */
@property (assign, nonatomic)NSInteger inspiration_activities_count;
/**
 *  图片URL
 */
@property (strong, nonatomic)NSString *photo_url;
/**
 *  标题
 */
@property (strong, nonatomic)NSString *topic;

@end
