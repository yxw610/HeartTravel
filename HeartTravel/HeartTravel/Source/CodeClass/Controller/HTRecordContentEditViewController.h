//
//  HTRecordContentEditViewController.h
//  WriteRecord
//
//  Created by 杨晓伟 on 16/1/27.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ContentPassBlock)(NSString *content);

@interface HTRecordContentEditViewController : UIViewController

@property (strong, nonatomic) UITextView *contentTextView;

@property (strong, nonatomic) ContentPassBlock contentPassBlock;

@end
