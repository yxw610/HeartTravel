//
//  HTDistrictModel.h
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTDistrictModel : NSObject

/**
 *  地区ID
 */
@property (assign, nonatomic) NSInteger district_id;

/**
 *  纬度
 */
@property (assign, nonatomic) CGFloat lat;

/**
 *  经度
 */
@property (assign, nonatomic) CGFloat lng;

/**
 *  地区名
 */
@property (strong, nonatomic) NSString *name;
@end
