//
//  JSON.m
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "JSON.h"
#import "HTTravelRecordModel.h"
#import "HTUserModel.h"
#import "HTDistrictModel.h"
#import "HTCategoryModel.h"
#import "HTRecordContentModel.h"

#define URL @"http://q.chanyouji.com/api/v1/timelines.json?page=1&per=50"

@implementation JSON

- (void)ht_getDataWith:(PassValue)passValue {
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:URL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            
            self.dataArray = [NSMutableArray array];
            self.cellMarkArray = [NSMutableArray array];
            
            for (NSDictionary *tempDict in dict[@"data"]) {
                
                HTTravelRecordModel *recordModel = [HTTravelRecordModel new];
                
                [recordModel setValuesForKeysWithDictionary:tempDict[@"activity"]];
                
                [self.dataArray addObject:recordModel];
                [self.cellMarkArray addObject:@"part"];
                
            }
            
            passValue(self.dataArray, self.cellMarkArray);
            
        } else {
            
            NSLog(@"%@",error);
        }
        
    }];
    
    [dataTask resume];
    
}


@end
