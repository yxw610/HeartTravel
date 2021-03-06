//
//  HTTurnInfoViewController.h
//  ChouTi
//
//  Created by 史丽娜 on 16/1/29.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HTTurnInfoViewControllerDelegate <NSObject>

- (void)changeUserInfo;

@end

@interface HTTurnInfoViewController : UIViewController
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *genderLabel;
@property(strong,nonatomic)UITextField *nameText;
@property(strong,nonatomic)UITextField *genderText;
@property(strong,nonatomic)UIButton *genderButton;
@property(weak,nonatomic)id<HTTurnInfoViewControllerDelegate> delegate;



@end
