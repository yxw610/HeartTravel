//
//  HTRegisteViewController.h
//  ChouTi
//
//  Created by 史丽娜 on 16/1/15.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTRegisteViewController : UIViewController
/**
 *  用户名
 */
@property(strong,nonatomic)UITextField *useField;
/**
 *  密码
 */
@property(strong,nonatomic)UITextField *pssField;
/**
 *  再次输入密码
 */
@property(strong,nonatomic)UITextField *againField;
/**
 *  注册按钮
 */
@property(strong,nonatomic)UIButton *regButton;

/**
 *  背景图
 */
@property(strong,nonatomic)UIImageView *backImg;


@end
