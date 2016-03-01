//
//  HTDistrictSearchModel.h
//  WriteRecord
//
//  Created by 杨晓伟 on 16/1/27.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDistrictSearchModel : NSObject

/**
 *  地区ID
 */
@property (assign, nonatomic) NSInteger district_id;

/**
 *  地区名
 */
@property (strong, nonatomic) NSString *name;

@end
