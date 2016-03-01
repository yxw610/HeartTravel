//
//  HTMyViewController.h
//  ChouTi
//
//  Created by 史丽娜 on 16/1/26.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTMyViewControllerDelegate <NSObject>

- (void)changeLoginState;

@end


@interface HTMyViewController : UIViewController

/**
 *  代理
 */
@property(weak,nonatomic)id<HTMyViewControllerDelegate> delegate;

@end
