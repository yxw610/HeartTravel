//
//  GetUser.m
//  HeartTravel
//
//  Created by 杨晓伟 on 16/3/1.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "GetUser.h"
#import "AVOSCloud.h"

@implementation GetUser

static GetUser *currentUser = nil;

/**
 *  单例方法
 *
 *  @return 返回一个GetDataTools单例对象
 */
+ (instancetype)shareGetUser {

    if (currentUser == nil) {
        
        currentUser = [[GetUser alloc] init];

        AVUser *user = [AVUser currentUser];
        if (user == nil) {
            currentUser = nil;
        }else {
            AVQuery *query = [AVQuery queryWithClassName:@"UserInfo"];
            [query whereKey:@"user_id" equalTo:user[@"user_id"]];
            NSArray *userArray = [query findObjects];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                NSLog(@"%@",error);
            }];
            AVObject *resultUser = [userArray firstObject];
            currentUser.name = resultUser[@"name"];
            currentUser.photo_url = resultUser[@"photo_url"];
            currentUser.user_id = [resultUser[@"user_id"] integerValue];
        }
    }else {
        AVUser *user = [AVUser currentUser];
        if (user == nil) {
            currentUser = nil;
        } else {
            AVQuery *query = [AVQuery queryWithClassName:@"UserInfo"];
            [query whereKey:@"user_id" equalTo:user[@"user_id"]];
            NSArray *userArray = [query findObjects];

            AVObject *resultUser = [userArray firstObject];
            currentUser.name = resultUser[@"name"];
            currentUser.photo_url = resultUser[@"photo_url"];
            currentUser.user_id = [resultUser[@"user_id"] integerValue];
        }
    }
    
    return currentUser;
}

- (void)updateUserInfo {
    
    AVUser *user = [AVUser currentUser];
    if (user == nil) {
        return;
    }else {
        AVQuery *query = [AVQuery queryWithClassName:@"UserInfo"];
        [query whereKey:@"user_id" equalTo:user[@"user_id"]];
        NSArray *userArray = [query findObjects];
        AVObject *resultUser = [userArray firstObject];
        self.name = resultUser[@"name"];
        self.photo_url = resultUser[@"photo_url"];
        self.user_id = [resultUser[@"user_id"] integerValue];
    }

}

#pragma mark --完善单例--

// 重写allocWithZone方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    /**
     *  @synchronized 保护对象在多线程的情况下同时只有一个线程来访问
     */
    @synchronized(currentUser) {
        
        if (!currentUser) {
            
            currentUser = [super allocWithZone:zone];
        }
        
        return currentUser;
    }
}

- (instancetype)init {
    
    @synchronized(self) {
        
        self = [super init];
        return self;
    }
}

// 重写copy方法，防止因为调用copy方法而造成第二个对象
- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    
    return self;
}

- (id)copy {
    
    return self;
}

- (id)mutableCopy {
    
    return self;
}

@end
