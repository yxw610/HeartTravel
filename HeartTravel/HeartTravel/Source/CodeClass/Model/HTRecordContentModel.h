//
//  HTRecordContentModel.h
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTRecordContentModel : NSObject

/**
 *  图片说明
 */
@property (strong, nonatomic) NSString *caption;

/**
 *  图片高度
 */
@property (assign, nonatomic) NSInteger height;

/**
 *  图片宽度
 */
@property (assign, nonatomic) NSInteger width;

/**
 *  图片ID
 */
@property (assign, nonatomic) NSInteger photo_id;

/**
 *  图片URL
 */
@property (strong, nonatomic) NSString *photo_url;

/**
 *  图片位置
 */
@property (assign, nonatomic) NSInteger position;

@end
