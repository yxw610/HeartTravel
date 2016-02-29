//
//  HTDistrictSearchViewController.h
//  WriteRecord
//
//  Created by 杨晓伟 on 16/1/27.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTDistrictSearchModel;

typedef void(^DistrictPassBlock)(HTDistrictSearchModel *model);

@interface HTDistrictSearchViewController : UITableViewController

@property (strong, nonatomic) UISearchBar *districtSearchBar;

@property (strong, nonatomic) DistrictPassBlock districtPassBlock;

@end
