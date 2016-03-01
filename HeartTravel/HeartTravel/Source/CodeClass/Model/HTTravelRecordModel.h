//
//  HTTrabelRecordModel.h
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTUserModel;

@interface HTTravelRecordModel : NSObject

/**
 *  类别
 */
@property (strong, nonatomic) NSArray *categories;

/**
 *  评论个数
 */
@property (assign, nonatomic) NSInteger comments_count;

/**
 *  图片内容
 */
@property (strong, nonatomic) NSArray *contents;

/**
 *  图片个数
 */
@property (assign, nonatomic) NSInteger contents_count;

/**
 *  游记创建时间
 */
@property (strong, nonatomic) NSString *created_at;

/**
 *  游记内容
 */
@property (strong, nonatomic) NSString *desc;

/**
 *  区域id
 */
@property (assign, nonatomic) NSInteger district_id;

/**
 *  所在区域
 */
@property (strong, nonatomic) NSArray *districts;

/**
 *  收藏人数
 */
@property (assign, nonatomic) NSInteger favorites_count;

/**
 *  id号
 */
@property (assign, nonatomic) NSInteger model_id;

/**
 *  喜欢人数
 */
@property (assign, nonatomic) NSInteger likes_count;

/**
 *  制作时间
 */
@property (strong, nonatomic) NSString *made_at;

/**
 *  标题
 */
@property (strong, nonatomic) NSString *topic;

/**
 *  创建用户
 */
@property (strong, nonatomic) HTUserModel *userInfo;

/**
 *  分组
 */
@property (assign, nonatomic) NSInteger groupNum;

@end
