//
//  HTPlacesModel.h
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTPlacesModel : NSObject

/**
 *  地址
 */
@property (strong,nonatomic) NSString *address;
/**
 *  电话
 */
@property (strong,nonatomic) NSString *contact;
/**
 *  门票
 */
@property (strong,nonatomic) NSString *priceinfo;
/**
 *  开放时间
 */
@property (strong,nonatomic) NSString *opening_time;
/**
 *  游玩时间
 */
@property (strong,nonatomic) NSString *duration;

/**
 *  分类标签
 */
@property (strong,nonatomic) NSString *tag_cn;
/**
 *  菜系
 */
@property (strong,nonatomic) NSString *cuisines_cn;
/**
 *  小贴士
 */
@property (strong,nonatomic) NSString *tip;
/**
 *  星级
 */
@property (strong,nonatomic) NSString *star;

@end
