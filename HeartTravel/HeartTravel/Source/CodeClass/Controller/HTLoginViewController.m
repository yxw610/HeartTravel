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
#import <Masonry/Masonry.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HTHomeViewController.h"
#import "HTLeftMenuViewController.h"
#import "HTUserModel.h"
#import "HTLeftMenuViewController.h"
#import "GetUser.h"
#import "UIImageView+WebCache.h"



#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kLeftGap kWidth / 6.5
#define kGap kHeight / 20


@interface HTLoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)HTLeftMenuViewController *leftMenu;
@end

@implementation HTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    
    //背景图
    self.backImg = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backImg.image = [UIImage imageNamed:@"HTLogin_BackImage.jpg"];
    self.backImg.userInteractionEnabled = YES;
    [self.view addSubview:self.backImg];
    //加约束
    UIEdgeInsets defaultInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view).insets(defaultInsets);
        
    }];
    
    
     //背景图模糊效果
    FXBlurView *fxView = [[FXBlurView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    fxView.dynamic = NO;
    fxView.blurRadius = 15;
    fxView.tintColor = [UIColor clearColor];
    [self.backImg addSubview:fxView];
    
    [fxView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.backImg).insets(defaultInsets);
    }];

#pragma mark-----------------导航栏左按钮(返回)--------------
    UIImage * normalImg = [UIImage imageNamed:@"iconfont-iconfanhui-2"];
    normalImg = [normalImg imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:normalImg style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];

#pragma mark----------------用户----------------
    
    //用户名图
    self.useImg = [[UIImageView alloc]init];
    self.useImg.image = [UIImage imageNamed:@"HTLogin_User"];
    [self.backImg addSubview:self.useImg];
    
    //加约束
    UIEdgeInsets useImgInsets = UIEdgeInsetsMake(190,  1.5 *kGap, 0, 0);
    
    [self.useImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.backImg.mas_top).with.offset(useImgInsets.top);
        make.centerX.equalTo(weakSelf.backImg.mas_left).with.offset(useImgInsets.left);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    

    //输入用户名
    self.UseTextField = [[UITextField alloc]init];
    //self.textField1.backgroundColor = [UIColor redColor];
    self.UseTextField.placeholder = @"e_mail";
    self.UseTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.UseTextField.font = [UIFont systemFontOfSize:20];
    self.UseTextField.delegate = self;
    [self.backImg addSubview:self.UseTextField];
    
    //加约束
    UIEdgeInsets useTextInsets = UIEdgeInsetsMake(185, 10 , 0, kGap);
    
    [self.UseTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.backImg.mas_top).with.offset(useTextInsets.top);
        make.left.equalTo(weakSelf.useImg.mas_right).with.offset(useTextInsets.left);
        make.right.equalTo(weakSelf.backImg.mas_right).with.offset(-useTextInsets.right);
     
        make.height.equalTo(@40);
    }];
    

#pragma mark------------------密码------------------
    //密码图
    self.pssImg = [[UIImageView alloc]init];
    self.pssImg.image = [UIImage imageNamed:@"HTLogin_Password"];
    [self.backImg addSubview:self.pssImg];
    
    //加约束
    UIEdgeInsets pssImgInsets = UIEdgeInsetsMake( kGap * 1.5, kGap * 1.5, 0, 0);
    
    [self.pssImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.useImg.mas_bottom).with.offset(pssImgInsets.top);
        make.centerX.equalTo(weakSelf.backImg.mas_left).with.offset(pssImgInsets.left);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    

    //输入密码
    self.pssTextField = [[UITextField alloc]init];
    // self.textField2.backgroundColor = [UIColor redColor];
    self.pssTextField.placeholder = @"password";
    self.pssTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.pssTextField.font = [UIFont systemFontOfSize:20];
    self.pssTextField.secureTextEntry = YES;
    self.pssTextField.delegate = self;
    [self.backImg addSubview:self.pssTextField];
    
    
    //约束
    UIEdgeInsets pssTextField = UIEdgeInsetsMake(kGap +10, 10, 0, kGap);
    
    [self.pssTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.UseTextField.mas_bottom).with.offset(pssTextField.top);
        make.left.equalTo(weakSelf.pssImg.mas_right).with.offset(pssTextField.left);
        make.right.equalTo(weakSelf.backImg.mas_right).with.offset(-pssTextField.right);
        make.height.equalTo(@40);
    }];
    

    
#pragma mark------------------登陆按钮------------------
    //登陆按钮
    self.loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
                        
    self.loginButton.backgroundColor = [UIColor grayColor];
    self.loginButton.layer.cornerRadius = 10;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.loginButton.alpha = 0.35;
    [self.loginButton addTarget:self action:@selector(backRoot:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.backImg addSubview:self.loginButton];
    
    
    //加约束
    UIEdgeInsets loginInsets = UIEdgeInsetsMake(2.3 * kGap, kGap * 1.5, 0, kGap* 1.5);
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.pssTextField.mas_bottom).with.offset(loginInsets.top);
        make.left.equalTo(weakSelf.backImg.mas_left).with.offset(loginInsets.left);
        make.right.equalTo(weakSelf.backImg.mas_right).with.offset(-loginInsets.right);
        make.height.equalTo(@40);
    }];
    

 #pragma mark------------------注册按钮------------------
    //注册按钮
    self.registerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.registerButton.backgroundColor = [UIColor grayColor];
    self.registerButton.layer.cornerRadius = 10;
    self.registerButton.layer.masksToBounds = YES;
    [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.view addSubview:self.registerButton];
    [self.registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backImg.backgroundColor = [UIColor whiteColor];

    UIEdgeInsets registerInsets = UIEdgeInsetsMake( 1.5* kGap, kGap * 1.5, 0, kGap* 1.5);
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(weakSelf.loginButton.mas_bottom).with.offset(registerInsets.top);
        
        make.left.equalTo(weakSelf.backImg.mas_left).with.offset(registerInsets.left);
        make.right.equalTo(weakSelf.backImg.mas_right).with.offset(-registerInsets.right);
        
        make.height.equalTo(@40);
    }];

    
    
    
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
        [alertController addAction:defaultAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }else
    {
       
        [AVUser logInWithUsernameInBackground: _UseTextField.text password:_pssTextField.text block:^(AVUser *user, NSError *error) {
            
            if (user != nil) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"登陆成功" preferredStyle:UIAlertControllerStyleAlert];
                  //__unsafe_unretained typeof(self) weakSelf = self;
                
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.delegate changeState];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }];
               
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:defaultAction];
                [alert addAction:cancelAction];
              [self presentViewController:alert animated:YES completion:nil];
            
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"登陆失败" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];

                [alert addAction:defaultAction];
             
                
                [self presentViewController:alert animated:YES completion:nil];

            }
        }];
    }
    
    

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


#pragma mark-------------左按钮--------------
- (void)leftAction:(UIBarButtonItem *)sender
{

    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击空白处,键盘返回
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


//键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //取消第一响应者:文本框成为第一响应者,就会弹出键盘,取消第一响应者就会收回键盘
    if (textField == self.UseTextField) {
        [self.pssTextField  becomeFirstResponder];
    }else
    {
        [textField resignFirstResponder];
    }
    return YES;
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
