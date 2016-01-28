//
//  HTDiscoveryHot.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDiscoveryHot : NSObject
/**
 *  目的地ID(实际id)
 */
@property (strong, nonatomic)NSString *ID;
/**
 *  地名
 */
@property (strong, nonatomic)NSString *name;
/**
 *  英文名
 */
@property (strong, nonatomic)NSString *name_en;
/**
 *  图片
 */
@property (strong, nonatomic)NSString *photo_url;


@end
