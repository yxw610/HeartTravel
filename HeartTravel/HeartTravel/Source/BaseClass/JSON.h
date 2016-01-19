//
//  JSON.h
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PassValue)(NSMutableArray *dataArray, NSMutableArray *cellMarkArray);

@interface JSON : NSObject

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *cellMarkArray;

- (void)ht_getDataWith:(PassValue)passValue;

@end
