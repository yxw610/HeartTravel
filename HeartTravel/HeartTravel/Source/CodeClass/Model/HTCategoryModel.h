//
//  HTCategoryModel.h
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCategoryModel : NSObject

/**
 *  类别类型
 */
@property (strong, nonatomic) NSString *category_type;

/**
 *  类别ID
 */
@property (assign, nonatomic) NSInteger category_id;

/**
 *  类别名
 */
@property (strong, nonatomic) NSString *name;
@end
