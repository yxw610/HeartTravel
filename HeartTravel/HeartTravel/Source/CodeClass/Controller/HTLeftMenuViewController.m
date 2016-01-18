//
//  HTLeftMenuViewController.m
//  ChouTi
//
//  Created by 史丽娜 on 16/1/15.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import "HTLeftMenuViewController.h"
#include <RESideMenu/RESideMenu.h>
#import "HTLoginViewController.h"
#import "FXBlurView.h"

@interface HTLeftMenuViewController ()

@end

@implementation HTLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backImg = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backImg.image = [UIImage imageNamed:@"1.jpg"];
    self.backImg.userInteractionEnabled = YES;
    [self.view addSubview:self.backImg];

//    //背景图模糊效果
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    visualView.frame = [UIScreen mainScreen].bounds;
    [self.backImg addSubview:visualView];
    
    
    FXBlurView *fxView = [[FXBlurView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    fxView.dynamic = NO;
    fxView.blurRadius = 15;
    fxView.tintColor = [UIColor clearColor];
    [self.backImg addSubview:fxView];
    

#pragma mark-----------------世界探索-------------------------
    self.worldButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.worldButton.frame = CGRectMake(70, 200, 100, 40);
    //self.worldButton.backgroundColor = [UIColor redColor];
    [self.worldButton setTitle:@"世界探索" forState:(UIControlStateNormal)];
    //左对齐
    self.worldButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.backImg addSubview:self.worldButton];
    
#pragma mark------------游记------------
    self.diaryButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.diaryButton.frame = CGRectMake(70, 270, 100, 40);
    //self.diaryButton.backgroundColor = [UIColor redColor];
    [self.diaryButton setTitle:@"游记" forState:(UIControlStateNormal)];
    //左对齐
    self.diaryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.backImg addSubview:self.diaryButton];
    
    #pragma mark------------发现------------
    self.findButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.findButton.frame = CGRectMake(70, 340, 100, 40);
    //self.findButton.backgroundColor = [UIColor redColor];
    [self.findButton setTitle:@"发现" forState:(UIControlStateNormal)];
    self.findButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.backImg addSubview:self.findButton];
    
#pragma mark----------------个人中心-----------------
    self.myButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.myButton.frame = CGRectMake(70, 410, 100, 40);
    //self.myButton.backgroundColor = [UIColor redColor];
    [self.myButton setTitle:@"个人中心" forState:(UIControlStateNormal)];
    self.myButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.backImg addSubview:self.myButton];

#pragma mark -------------------头像------------------
    self.headImg = [[UIImageView alloc]initWithFrame:(CGRectMake(80, 20, 80, 80))];
    self.headImg.image = [UIImage imageNamed:@"t.jpg"];
    self.headImg.layer.cornerRadius = 40;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.headImg addGestureRecognizer:tap];
    
    [self.backImg addSubview:self.headImg];
#pragma mark----------------名称------------------------
    self.nameButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.nameButton.frame = CGRectMake(70,110, 100, 30);
    self.nameButton.backgroundColor = [UIColor redColor];
    [self.nameButton setTitle:@"未登录" forState:(UIControlStateNormal)];
    
    [self.nameButton addTarget:self action:@selector(pageAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.backImg addSubview:self.nameButton];
    

    
    
    
    
}
//nameButton 点击事件
- (void)pageAction:(UIButton *)sender
{
    HTLoginViewController *loginVC = [[HTLoginViewController alloc]init];
 UINavigationController *loginNC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:loginNC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//轻拍手势
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    HTLoginViewController *loginVC = [[HTLoginViewController alloc]init];
    UINavigationController *loginNC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:loginNC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
