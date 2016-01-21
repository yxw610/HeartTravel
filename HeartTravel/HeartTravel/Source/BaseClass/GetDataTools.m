//
//  GetDataTools.m
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "GetDataTools.h"
#import "AFNetworking.h"

@implementation GetDataTools

static GetDataTools *getDataTools = nil;

/**
 *  单例方法
 *
 *  @return 返回一个GetDataTools单例对象
 */
+ (instancetype)shareGetDataTools {
    
    if (getDataTools == nil) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            getDataTools = [[GetDataTools alloc] init];
        });
    }
    
    return getDataTools;
}

/**
 *  解析数据
 *
 *  @param url   url地址
 *  @param block block回调传值
 */
- (void)getDataWithUrlString:(NSString *)url data:(PassValueBlock)block {
    
    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        block(dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            
            [self getDataUseSessionManagerWith:url data:block];
        }
    }];
}

/**
 *  使用系统自带的系统解析
 *
 *  @param url   url地址
 *  @param block block回调传值
 */
- (void)getDataUseSessionManagerWith:(NSString *)url data:(PassValueBlock)block {
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            block(dict);
        }
    }];
    
    [dataTask resume];

}





#pragma mark --完善单例--

// 重写allocWithZone方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    /**
     *  @synchronized 保护对象在多线程的情况下同时只有一个线程来访问
     */
    @synchronized(getDataTools) {
        
        if (!getDataTools) {
            
            getDataTools = [super allocWithZone:zone];
        }
        
        return getDataTools;
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
