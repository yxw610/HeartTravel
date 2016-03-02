//
//  HTRegisteViewController.m
//  ChouTi
//
//  Created by 史丽娜 on 16/1/15.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import "HTRegisteViewController.h"
#import "FXBlurView.h"
#import <Masonry/Masonry.h>
#import <AVOSCloud/AVOSCloud.h>

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kLeftGap kWidth / 6.5
#define kGap kHeight / 20

@interface HTRegisteViewController ()<UITextFieldDelegate>

@end

@implementation HTRegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"注册";
   // self.navigationController.navigationBarHidden = YES;
    self.backImg = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backImg.image = [UIImage imageNamed:@"HTRegister_BackImage.jpg"];
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
    
    [fxView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.backImg).insets(defaultInsets);
    }];

    //用户名
    self.useField = [[UITextField alloc]init];
    
    //self.useField.backgroundColor = [UIColor blueColor];
    self.useField.placeholder = @"E-mail";
    self.useField.borderStyle = UITextBorderStyleRoundedRect;
    self.useField.delegate = self;
    [self.backImg addSubview:self.useField];
    //加约束
    
    UIEdgeInsets useTextInsets = UIEdgeInsetsMake(190, 2 *kGap  , 0,  2 * kGap );
    
    [self.useField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.backImg.mas_top).with.offset(useTextInsets.top);
        
        make.left.equalTo(weakSelf.backImg.mas_left).with.offset(useTextInsets.left);
        
        make.right.equalTo(weakSelf.backImg.mas_right).with.offset(-useTextInsets.right);
        
        make.height.equalTo(@40);
    }];

    
    //输入密码
    self.pssField = [[UITextField alloc]init];
    //self.pssField.backgroundColor = [UIColor orangeColor];
    self.pssField.placeholder = @"Password";
    self.pssField.borderStyle = UITextBorderStyleRoundedRect;
    self.pssField.secureTextEntry = YES;
    self.pssField.delegate = self;
    [self.backImg addSubview:self.pssField];
    //加约束
    UIEdgeInsets  pssTextInsets = UIEdgeInsetsMake(kGap, 2 *kGap  , 0,  2 * kGap );
    [self.pssField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.useField.mas_bottom).with.offset(pssTextInsets.top);
        
        make.left.equalTo(weakSelf.backImg.mas_left).with.offset(pssTextInsets.left);
        
        make.right.equalTo(weakSelf.backImg.mas_right).with.offset(-pssTextInsets.right);
        
        make.height.equalTo(@40);
    }];
    

    
    
    //再次输入密码
    self.againField = [[UITextField alloc]init];
    //self.againField.backgroundColor = [UIColor redColor];
    self.againField.placeholder = @"Password+1";
    self.againField.borderStyle =  UITextBorderStyleRoundedRect;
    self.againField.secureTextEntry = YES;
    self.againField.delegate = self;
    [self.backImg addSubview:self.againField];
    //加约束
    
    
    [self.againField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.pssField.mas_bottom).with.offset(pssTextInsets.top);
        
        make.left.equalTo(weakSelf.backImg.mas_left).with.offset(pssTextInsets.left);
        
        make.right.equalTo(weakSelf.backImg.mas_right).with.offset(-pssTextInsets.right);
        
        make.height.equalTo(@40);
    }];

    //注册按钮
    self.regButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.regButton.backgroundColor = [UIColor grayColor];
    self.regButton.layer.cornerRadius = 10;
    [self.regButton setTitle:@"Register" forState:UIControlStateNormal];
    self.regButton.layer.masksToBounds = YES;
    [self.regButton addTarget:self action:@selector(regButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.backImg addSubview:self.regButton];

    UIEdgeInsets regInsets = UIEdgeInsetsMake( 2* kGap, 1.5 *kGap  , 0, 1.5 * kGap  );
    
    [self.regButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.againField.mas_bottom).with.offset(regInsets.top);
        
        make.left.equalTo(weakSelf.backImg.mas_left).with.offset(regInsets.left);
        
        make.right.equalTo(weakSelf.backImg.mas_right).with.offset(-regInsets.right);
        
        make.height.equalTo(@40);
    }];

    
}


- (void)regButton:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    if ([_useField.text isEqualToString:@""] || [_pssField.text isEqualToString:@""] || [_againField.text isEqualToString:@""])
    {
        alertController.message = @"不能为空";
        [alertController addAction:defaultAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else if(![_pssField.text  isEqualToString:_againField.text])
    {
        alertController.message = @"不符";
        [alertController addAction:defaultAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else
    {
        AVUser *user = [AVUser user];
        user.username =  _useField.text;
        user.password =  _pssField.text;
        user.email = _useField.text;
       
        if ([self isValidateEmail:user.email]) {
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {

                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
                    __unsafe_unretained typeof(self) weakSelf = self;
                    
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];

                }else
                {
                    NSLog(@"%@", error);
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册失败" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                    
                    [alert addAction:defaultAction];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }
    }
}


-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
    if (textField == self.useField ) {
        [self.pssField  becomeFirstResponder];
    }else if(textField == self.pssField)
    {
        [self.againField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];

    }
    return YES;
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
