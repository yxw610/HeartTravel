//
//  HJTableViewHeader.m
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/22.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HJTableViewHeader.h"
#import "UIView+WLFrame.h"
//屏幕尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation HJTableViewHeader
{
    CGRect initFrame;
    CGFloat defaultViewHeight;
    CGRect subViewsFrame;
}

-(void)goodMenWithTableView:(UITableView *)tableView andBackGroundView:(UIView *)view andSubViews:(UIView *)subViews {
    
    _tableView = tableView;
    _bigImageView = view;
    _scoreView = subViews;
    initFrame = _bigImageView.frame;
    defaultViewHeight  = initFrame.size.height;
    subViewsFrame = _scoreView.frame;
    UIView* heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _bigImageView.height + _scoreView.height)];
    [_tableView addSubview:_scoreView];
    [_tableView addSubview:_bigImageView];
    self.tableView.tableHeaderView = heardView;
}

-(void)goodMenWithTableView:(UITableView *)tableView andBackGroundView:(UIView *)view {
    
    _tableView = tableView;
    _bigImageView = view;
    initFrame = _bigImageView.frame;
    defaultViewHeight  = initFrame.size.height;
    
    UIView* heardView = [[UIView alloc]initWithFrame:initFrame];
    self.tableView.tableHeaderView = heardView;
    [_tableView addSubview:_bigImageView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect f = _bigImageView.frame;
    f.size.width = _tableView.frame.size.width;
    _bigImageView.frame  = f;
    
    if (scrollView.contentOffset.y < 0) {
        CGFloat offset = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        initFrame.origin.x = - offset / 2;
        initFrame.origin.y = - offset;
        initFrame.size.width = _tableView.frame.size.width + offset;
        initFrame.size.height = defaultViewHeight + offset;
        _bigImageView.frame = initFrame;
    }
}

@end
