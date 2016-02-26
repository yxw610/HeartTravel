//
//  HJTableViewHeader.h
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/22.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HJTableViewHeader : NSObject

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *bigImageView;
@property (nonatomic,strong) UIView *scoreView;
- (void)goodMenWithTableView:(UITableView *)tableView andBackGroundView:(UIView*)view andSubViews:(UIView *)subViews;
- (void)goodMenWithTableView:(UITableView*)tableView andBackGroundView:(UIView*)view;

- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
@end
