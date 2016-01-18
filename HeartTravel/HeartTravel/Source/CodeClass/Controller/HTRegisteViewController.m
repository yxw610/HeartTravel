//
//  HTRegisteViewController.m
//  ChouTi
//
//  Created by 史丽娜 on 16/1/15.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import "HTRegisteViewController.h"
#import "FXBlurView.h"
@interface HTRegisteViewController ()

@end

@implementation HTRegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"注册";
   // self.navigationController.navigationBarHidden = YES;
    self.backImg = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backImg.image = [UIImage imageNamed:@"3.jpg"];
    self.backImg.userInteractionEnabled = YES;
    [self.view addSubview:self.backImg];
//    //背景图模糊效果
//    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
//    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:beffect];
//    visualView.frame = [UIScreen mainScreen].bounds;
//    [self.backImg addSubview:visualView];
    
    FXBlurView *fxView = [[FXBlurView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    fxView.dynamic = NO;
    fxView.blurRadius = 15;
    fxView.tintColor = [UIColor clearColor];
    [self.backImg addSubview:fxView];

    //用户名
    self.useField = [[UITextField alloc]initWithFrame:CGRectMake(40, 100, 250, 40)];
    //self.useField.backgroundColor = [UIColor blueColor];
    self.useField.placeholder = @"Username";
    self.useField.borderStyle = UITextBorderStyleRoundedRect;
    [self.backImg addSubview:self.useField];
    //输入密码
    self.pssField = [[UITextField alloc]initWithFrame:CGRectMake(40, 180, 250, 40)];
    //self.pssField.backgroundColor = [UIColor orangeColor];
    self.pssField.placeholder = @"Password";
    self.pssField.borderStyle = UITextBorderStyleRoundedRect;
    self.pssField.secureTextEntry = YES;
    [self.backImg addSubview:self.pssField];
    //再次输入密码
    self.againField = [[UITextField alloc]initWithFrame:CGRectMake(40, 260, 250, 40)];
    //self.againField.backgroundColor = [UIColor redColor];
    self.againField.placeholder = @"Password+1";
    self.againField.borderStyle =  UITextBorderStyleRoundedRect;
    self.againField.secureTextEntry = YES;
    [self.backImg addSubview:self.againField];
    
    //注册按钮
    self.regButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 360, 220, 40)];
    self.regButton.backgroundColor = [UIColor grayColor];
    self.regButton.layer.cornerRadius = 10;
    [self.regButton setTitle:@"Register" forState:UIControlStateNormal];
    self.regButton.layer.masksToBounds = YES;
    [self.regButton addTarget:self action:@selector(regButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.backImg addSubview:self.regButton];

    
       


}


- (void)regButton:(UIButton *)sender
{
//    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    if ([_useField.text isEqualToString:@""] || [_pssField.text isEqualToString:@""] || [_againField.text isEqualToString:@""])
    {
        alertController.message = @"不能为空";
        
    }else if(![_pssField.text  isEqualToString:_againField.text])
    {
        alertController.message = @"不符";
    }else
    {
        alertController.message = @"恭喜您注册成功";
        
        __unsafe_unretained typeof(self) weakSelf = self;
        
        defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    

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
