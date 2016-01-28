//
//  HTStrategyModel.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTStrategyPhoto;

@interface HTStrategyModel : NSObject

@property (strong, nonatomic)NSString *activity_category;
@property (strong, nonatomic)NSString *cropping_url;
@property (strong, nonatomic)NSDictionary *district;
@property (strong, nonatomic)NSString *icon_type;
@property (strong, nonatomic)NSString *strategy_id;
@property (strong, nonatomic)NSString *introduce;
@property (strong, nonatomic)HTStrategyPhoto *photo;
@property (strong, nonatomic)NSString *summary;
@property (strong, nonatomic)NSString *topic;
@property (strong, nonatomic)NSString *visit_tip;
@property (assign, nonatomic)NSInteger wishes_count;

@end
