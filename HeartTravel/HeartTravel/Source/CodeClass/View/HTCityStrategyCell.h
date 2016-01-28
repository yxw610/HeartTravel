//
//  HTCityStrategyCell.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCityStrategyModel.h"

@interface HTCityStrategyCell : UITableViewCell

/**
 *  攻略类型图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
/**
 *  类型主题
 */
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
/**
 *  旅行灵感数
 */
@property (weak, nonatomic) IBOutlet UILabel *inspirationCountLabel;

@property (strong, nonatomic)HTCityStrategyModel *model;

@end
