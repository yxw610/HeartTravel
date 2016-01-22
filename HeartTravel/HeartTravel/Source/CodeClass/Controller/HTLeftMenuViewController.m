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
#import <Masonry/Masonry.h>
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kLeftGap kWidth / 4
#define kButtonGap kHeight / 20


@interface HTLeftMenuViewController ()

@end

@implementation HTLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backImg = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backImg.image = [UIImage imageNamed:@"HTLeftMenu_BackImage.jpg"];
    self.backImg.userInteractionEnabled = YES;
    [self.view addSubview:self.backImg];
    //加约束
    UIEdgeInsets defaultInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view).insets(defaultInsets);
        
    }];

//    //背景图模糊效果
    
    FXBlurView *fxView = [[FXBlurView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    fxView.dynamic = NO;
    fxView.blurRadius = 15;
    fxView.tintColor = [UIColor clearColor];
    [self.backImg addSubview:fxView];
      //加约束
    [fxView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.backImg).insets(defaultInsets);
    }];
#pragma mark -------------------头像------------------
    self.headImg = [[UIImageView alloc]init];
    self.headImg.image = [UIImage imageNamed:@"HTLeftMenu_Head"];
    self.headImg.layer.cornerRadius = 35;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.headImg addGestureRecognizer:tap];
    
    [self.backImg addSubview:self.headImg];
    
    //加约束
    UIEdgeInsets headInsets = UIEdgeInsetsMake(70, kLeftGap + 50, 0, 0);
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.backImg.mas_top).with.offset(headInsets.top);
        make.centerX.equalTo(weakSelf.backImg.mas_left).with.offset(headInsets.left);
        make.width.equalTo(@70);
        make.height.equalTo(@70);
    }];

#pragma mark----------------名称------------------------
    self.nameButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    //self.nameButton.backgroundColor = [UIColor redColor];
    [self.nameButton setTitle:@"未登录" forState:(UIControlStateNormal)];
    
    [self.nameButton addTarget:self action:@selector(pageAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.backImg addSubview:self.nameButton];
    //加约束
    UIEdgeInsets nameInsets = UIEdgeInsetsMake(0, kLeftGap +50, 0, 0);
    
    [self.nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.backImg.mas_left).with.offset(nameInsets.left);
        make.top.equalTo(weakSelf.headImg.mas_bottom).with.offset(nameInsets.top);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    

    
    

#pragma mark-----------------世界探索-------------------------
    self.worldButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
   
    //self.worldButton.backgroundColor = [UIColor redColor];
    [self.worldButton setTitle:@"世界探索" forState:(UIControlStateNormal)];
    //左对齐
    self.worldButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.backImg addSubview:self.worldButton];
    //加约束(上.左.下.右)
    UIEdgeInsets buttonInsets = UIEdgeInsetsMake(kButtonGap, kLeftGap , 0, 0);
    
    [self.worldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameButton.mas_bottom).with.offset(buttonInsets.top);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.left.equalTo(weakSelf.backImg.mas_left).with.offset(buttonInsets.left);
        
    }];

#pragma mark------------游记------------
    self.diaryButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
  
    //self.diaryButton.backgroundColor = [UIColor redColor];
    [self.diaryButton setTitle:@"游记" forState:(UIControlStateNormal)];
    //左对齐
    self.diaryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.backImg addSubview:self.diaryButton];
    //加约束(上.左.下.右)

    [self.diaryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.worldButton.mas_bottom).with.offset(buttonInsets.top);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.left.equalTo(weakSelf.backImg.mas_left).with.offset(buttonInsets.left);
        
    }];

    #pragma mark------------发现------------
    self.findButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //self.findButton.backgroundColor = [UIColor redColor];
    [self.findButton setTitle:@"发现" forState:(UIControlStateNormal)];
    self.findButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.backImg addSubview:self.findButton];
    
    [self.findButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.diaryButton.mas_bottom).with.offset(buttonInsets.top);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.left.equalTo(weakSelf.backImg.mas_left).with.offset(buttonInsets.left);
        
    }];
    

#pragma mark----------------个人中心-----------------
    self.myButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
  
    //self.myButton.backgroundColor = [UIColor redColor];
    [self.myButton setTitle:@"个人中心" forState:(UIControlStateNormal)];
    self.myButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.backImg addSubview:self.myButton];

    [self.myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.findButton.mas_bottom).with.offset(buttonInsets.top);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.left.equalTo(weakSelf.backImg.mas_left).with.offset(buttonInsets.left);
    }];
    
    
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
