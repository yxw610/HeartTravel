//
//  HTLoginViewController.h
//  ChouTi
//
//  Created by 史丽娜 on 16/1/15.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTLoginViewControllerDelegate <NSObject>

- (void)changeState;

@end


@interface HTLoginViewController : UIViewController

/**
 *  代理
 */
@property(weak,nonatomic)id<HTLoginViewControllerDelegate> delegate;
/**
 *  用户图
 */
@property(strong,nonatomic)UIImageView *useImg;
/**
 *  密码图
 */
@property(strong,nonatomic)UIImageView *pssImg;
/**
 *  用户名
 */
@property(strong,nonatomic)UITextField *UseTextField;
/**
 *  密码
 */
@property(strong,nonatomic)UITextField *pssTextField;
/**
 *  登陆按钮
 */
@property(strong,nonatomic)UIButton *loginButton;
/**
 *  注册按钮
 */
@property(strong,nonatomic)UIButton *registerButton;
/**
 *  背景图
 */
@property(strong,nonatomic)UIImageView *backImg;


@end
