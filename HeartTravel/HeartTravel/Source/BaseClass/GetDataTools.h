//
//  GetDataTools.h
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PassValueBlock)(NSDictionary *dataDict);

@interface GetDataTools : NSObject <NSCopying, NSMutableCopying>

/**
 *  单例方法
 *
 *  @return 返回一个GetDataTools单例对象
 */
+ (instancetype)shareGetDataTools;

/**
 *  解析数据
 *
 *  @param url   url地址
 *  @param block block回调传值
 */
- (void)getDataWithUrlString:(NSString *)url data:(PassValueBlock)block;

@end
