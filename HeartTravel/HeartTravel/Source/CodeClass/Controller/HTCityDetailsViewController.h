//
//  HTCityDetailsViewController.h
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/19.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <WMPageController/WMPageController.h>

@interface HTCityDetailsViewController : WMPageController

@property (strong,nonatomic) NSString *headerName;

- (instancetype) initWithPlaceID:(NSString *)palceID;

@end
