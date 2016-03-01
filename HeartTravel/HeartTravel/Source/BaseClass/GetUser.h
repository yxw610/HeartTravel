//
//  GetUser.h
//  HeartTravel
//
//  Created by 杨晓伟 on 16/3/1.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetUser : NSObject

/**
 *  当前用户名
 */
@property (strong, nonatomic) NSString *name;

/**
 *  用户ID
 */
@property (assign, nonatomic) NSInteger user_id;

/**
 *  头像地址
 */
@property (strong, nonatomic) NSString *photo_url;

/**
 *  单例方法
 *
 *  @return 返回一个GetUser单例对象
 */
+ (instancetype)shareGetUser;

@end
