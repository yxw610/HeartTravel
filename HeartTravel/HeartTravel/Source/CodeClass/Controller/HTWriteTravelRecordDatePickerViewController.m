//
//  HTWriteTravelRecordDatePickerViewController.m
//  WriteRecord
//
//  Created by 杨晓伟 on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTWriteTravelRecordDatePickerViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HTWriteTravelRecordDatePickerViewController ()

@end

@implementation HTWriteTravelRecordDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2, kScreenHeight, kScreenHeight / 2)];
    
    datePicker.datePickerMode = UIDatePickerModeTime;
    
    [self.view addSubview:datePicker];


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
