//
//  HTLoginViewController.m
//  ChouTi
//
//  Created by 史丽娜 on 16/1/15.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import "HTLoginViewController.h"
#import "HTRegisteViewController.h"
#import "FXBlurView.h"

@interface HTLoginViewController ()

@end

@implementation HTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //背景图
    self.backImg = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backImg.image = [UIImage imageNamed:@"2.jpg"];
    self.backImg.userInteractionEnabled = YES;
    [self.view addSubview:self.backImg];
    //背景图模糊效果
//    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
//    
//    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:beffect];
//    visualView.frame = [UIScreen mainScreen].bounds;
//    [self.backImg addSubview:visualView];
    
     //背景图模糊效果
    FXBlurView *fxView = [[FXBlurView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    fxView.dynamic = NO;
    fxView.blurRadius = 15;
    fxView.tintColor = [UIColor clearColor];
    [self.backImg addSubview:fxView];

    
    
    
    //用户名图
    self.useImg = [[UIImageView alloc]initWithFrame:CGRectMake(30, 150, 30, 30)];
    self.useImg.image = [UIImage imageNamed:@"iconfont-denglu"];
    [self.backImg addSubview:self.useImg];
    
    //输入用户名
    self.UseTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, 145, 210, 40)];
    //self.textField1.backgroundColor = [UIColor redColor];
    self.UseTextField.placeholder = @"username";
    self.UseTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.UseTextField.font = [UIFont systemFontOfSize:20];
    [self.backImg addSubview:self.UseTextField];
    
    //密码图
    self.pssImg = [[UIImageView alloc]initWithFrame:CGRectMake(30, 230, 30, 30)];
    self.pssImg.image = [UIImage imageNamed:@"iconfont-mima-3"];
    [self.backImg addSubview:self.pssImg];
    
    //输入密码
    self.pssTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, 225, 210, 40)];
    // self.textField2.backgroundColor = [UIColor redColor];
    self.pssTextField.placeholder = @"password";
    self.pssTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.pssTextField.font = [UIFont systemFontOfSize:20];
    self.pssTextField.secureTextEntry = YES;
    [self.backImg addSubview:self.pssTextField];
    
    //登陆按钮
    self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 330, 220, 40)];
    self.loginButton.backgroundColor = [UIColor grayColor];
    self.loginButton.layer.cornerRadius = 10;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginButton.alpha = 0.3;
    [self.loginButton addTarget:self action:@selector(backRoot:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.backImg addSubview:self.loginButton];
    //注册按钮
    self.registerButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 410, 220, 40)];
    self.registerButton.backgroundColor = [UIColor grayColor];
    self.registerButton.layer.cornerRadius = 10;
    self.registerButton.layer.masksToBounds = YES;
    [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.view addSubview:self.registerButton];
    [self.registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backImg.backgroundColor = [UIColor whiteColor];

    
    
    
    
}


//登陆的点击事件
- (void)backRoot:(UIButton *)sender
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    if ([_UseTextField.text isEqualToString:@""] || [_pssTextField.text isEqualToString:@""])
    {
        alertController.message = @"不能为空";
    }else
    {
        alertController.message = @"恭喜您登陆成功";
    }
    
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];


}

//注册的点击事件
- (void)registerAction:(UIButton *)sender
{
    HTRegisteViewController *registeVC = [[HTRegisteViewController alloc]init];
   
    [self.navigationController pushViewController:registeVC animated:YES];
  }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
