//
//  HTLeftMenuViewController.h
//  ChouTi
//
//  Created by 史丽娜 on 16/1/15.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTLeftMenuViewController : UIViewController
@property(strong,nonatomic)UIButton *worldButton;
/**
 *  世界搜索
 */
@property(strong,nonatomic)UIButton *diaryButton;
/**
 *  发现
 */
@property(strong,nonatomic)UIButton *findButton;
/**
 *  个人中心
 */
@property(strong,nonatomic)UIButton *myButton;
/**
 *  头像
 */
@property(strong,nonatomic)UIImageView *headImg;
/**
 *  名称
 */
@property(strong,nonatomic)UIButton *nameButton;
/**
 *  背景图片
 */
@property(strong,nonatomic)UIImageView *backImg;











@end
