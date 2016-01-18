//
//  HTHomeViewController.m
//  ChouTi
//
//  Created by 史丽娜 on 16/1/15.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import "HTHomeViewController.h"
#import "HTLeftMenuViewController.h"
#import <RESideMenu/RESideMenu.h>
@interface HTHomeViewController ()

@end

@implementation HTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor redColor];
    
    UIImage *normalImg = [UIImage imageNamed:@"iconfont-gongneng-2"];
    normalImg = [normalImg imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithImage:normalImg style:UIBarButtonItemStylePlain target:self action:@selector(changeLeft:)];
    
    
    
}
//功能按钮的实现
- (void)changeLeft:(UIBarButtonItem *)sender
{
   
    [self.sideMenuViewController presentLeftMenuViewController];
    
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
