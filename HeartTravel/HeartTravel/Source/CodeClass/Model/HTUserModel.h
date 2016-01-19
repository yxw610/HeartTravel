//
//  HTUserModel.h
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTUserModel : NSObject

/**
 *  性别
 */
@property (assign, nonatomic) NSInteger gender;

/**
 *  用户ID
 */
@property (assign, nonatomic) NSInteger user_id;

/**
 *  级别
 */
@property (assign, nonatomic) NSInteger level;

/**
 *  用户名
 */
@property (strong, nonatomic) NSString *name;

/**
 *  用户头像URL
 */
@property (strong, nonatomic) NSString *photo_url;

@end
