//
//  HTDiscoverDetailCell.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTDestinationStrategy.h"

@interface HTDestinationStrategyCell : UITableViewCell

/**
 *  城市图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *detailImgView;
/**
 *  城市名
 */
@property (weak, nonatomic) IBOutlet UILabel *detailNameLabel;
/**
 *  旅游灵感数
 */
@property (weak, nonatomic) IBOutlet UILabel *inspirationLabel;

@property (strong, nonatomic)HTDestinationStrategy *detail;

@end
