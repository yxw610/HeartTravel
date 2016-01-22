//
//  HTCityDetailsModel.h
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/19.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCityDetailsModel : NSObject
/**
 *  景点名字
 */
@property (strong,nonatomic) NSString *name_cn;
/**
 *  景点英文名字
 */
@property (strong,nonatomic) NSString *name;
/**
 *  背景图片
 */
@property (strong,nonatomic) NSString *path;
/**
 *  评分
 */
@property (strong,nonatomic) NSString *score;
/**
 *  点评
 */
@property (strong,nonatomic) NSString *reviewCount;
/**
 *  价格
 */
@property (strong,nonatomic) NSString *price;
/**
 *  id
 */
@property (strong,nonatomic) NSString *ID;

@end
