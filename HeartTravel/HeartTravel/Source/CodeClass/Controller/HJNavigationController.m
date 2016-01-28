//
//  HJNavigationController.m
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HJNavigationController.h"
#import "HJNavigationBar.h"
//屏幕尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HJNavigationController ()

@end

@implementation HJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    HJNavigationBar *bar = [[HJNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [self setValue:bar forKey:@"navigationBar"];
    self.navigationBar.barTintColor = [UIColor purpleColor];
    // 3.设置导航条标题的字体和颜色
    NSDictionary *titleAttr = @{
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:15]
                                };
    
    self.navigationBar.titleTextAttributes = titleAttr;
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
