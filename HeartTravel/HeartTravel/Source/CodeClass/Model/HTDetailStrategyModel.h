//
//  HTDetailStrategyModel.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/26.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTStrategyPhoto;
@class HTDistrictModel;

@interface HTDetailStrategyModel : NSObject

@property (strong, nonatomic) NSString *activity_category;
@property (strong, nonatomic) NSArray *activity_collections;
@property (strong, nonatomic) NSString *cropping_url;
@property (assign, nonatomic) BOOL current_user_completed;
@property (strong, nonatomic) NSDictionary *destination;
@property (strong, nonatomic) HTDistrictModel *district;
@property (strong, nonatomic) NSString *icon_type;
@property (strong, nonatomic) NSString *detail_id;
@property (strong, nonatomic) NSString *introduce;
@property (strong, nonatomic) HTStrategyPhoto *photo;
@property (strong, nonatomic) NSArray *pois;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *tip;
@property (strong, nonatomic) NSString *topic;
@property (assign, nonatomic) NSInteger user_activities_count;
@property (strong, nonatomic) NSDictionary *user_activity;
@property (strong, nonatomic) NSString *visit_tip;
@property (strong, nonatomic) NSString *wiki_page;
@property (assign, nonatomic) BOOL wished;
@property (assign, nonatomic) NSInteger wishes_count;

@end
