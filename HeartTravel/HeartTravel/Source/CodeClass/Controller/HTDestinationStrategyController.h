//
//  HTDiscoveryDetailViewController.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTDestinationStrategyController : UITableViewController
/**
 *  承接上个页面传过来的id
 */
@property (strong, nonatomic)NSString *stringID;
/**
 *  攻略的地名
 */
@property (strong, nonatomic)NSString *string;

@end
