//
//  HTPlacesViewController.m
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/22.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTPlacesViewController.h"
#import "HJTableViewHeader.h"
#import "HJNavigationBar.h"
#import <UIImageView+WebCache.h>
#import <MDRadialProgressTheme.h>
#import <MDRadialProgressLabel.h>
#import <MDRadialProgressView.h>

@interface HTPlacesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)HJTableViewHeader* headView;
@property(nonatomic,strong)UIImageView* bigImageView;

@end

@implementation HTPlacesViewController

- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTableView];
    _bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.koubeilvxing.com/pics%@",self.backView]]];
    _bigImageView.clipsToBounds = YES;
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headView = [[HJTableViewHeader alloc]init];
    [_headView goodMenWithTableView:self.tableView andBackGroundView:_bigImageView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavbarBackgroundHidden:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HTiconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction)];
}

- (void)leftButtonAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setNavbarBackgroundHidden:(BOOL)hidden {
    
    HJNavigationBar *navBar = (HJNavigationBar *)self.navigationController.navigationBar;
    if (!hidden) {
        [navBar show];
    } else {
        [navBar hidden];
    }
    
}

- (void)getTableView {
    
    [self.view addSubview: self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 30;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text=[NSString stringWithFormat:@"这是第%@个Cell",@(indexPath.row)];
    
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_headView scrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y < self.bigImageView.frame.size.height - 64) {
        [self setNavbarBackgroundHidden:YES];
    } else {
        
        [self setNavbarBackgroundHidden:NO];
    }
}
@end
