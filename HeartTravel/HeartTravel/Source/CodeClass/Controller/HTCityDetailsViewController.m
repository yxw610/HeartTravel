//
//  HTCityDetailsViewController.m
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/19.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTCityDetailsViewController.h"
#import "HTCityFieldTableViewController.h"

@interface HTCityDetailsViewController ()


@end

@implementation HTCityDetailsViewController

- (instancetype) initWithPlaceID:(NSString *)palceID {
    
    if (self = [super init]) {
        self.titles = @[@"景点",@"餐馆",@"酒店",@"购物",@"活动"];
        self.viewControllerClasses = @[[HTCityFieldTableViewController class],[HTCityFieldTableViewController class],[HTCityFieldTableViewController class],[HTCityFieldTableViewController class],[HTCityFieldTableViewController class]];
        self.keys=@[@"urlArray",@"urlArray",@"urlArray",@"urlArray",@"urlArray"].mutableCopy;
        self.values=@[@[@0,palceID],@[@1,palceID],@[@2,palceID],@[@3,palceID],@[@4,palceID]].mutableCopy;
        self.titleColorSelected = [UIColor grayColor];
        self.menuViewStyle = WMMenuViewStyleLine;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.headerName];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HTiconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonAction)];
}

- (void)leftButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
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
