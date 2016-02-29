//
//  HTRecordContentEditViewController.m
//  WriteRecord
//
//  Created by 杨晓伟 on 16/1/27.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTRecordContentEditViewController.h"
#import "HTNavigationBar.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HTRecordContentEditViewController ()

@end

@implementation HTRecordContentEditViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self drawView];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.contentTextView];
    
    self.navigationItem.hidesBackButton = YES;
    
    HTNavigationBar *htBar = [HTNavigationBar new];
    htBar.titleLabel.text = @"写游记";
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(htBar.frame.size.width - 45, 20, 40, htBar.frame.size.height - 20);
    [commitButton setTitle:@"确定" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [commitButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [htBar.barColorView addSubview:commitButton];
    
    [self.navigationController setValue:htBar forKey:@"navigationBar"];
    
}

- (void)drawView {
    
    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 216)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commitAction:(UIButton *)sender {
    
    if ([_contentTextView.text isEqualToString:@""]) {
        
    } else {
        
        self.contentPassBlock(_contentTextView.text);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
