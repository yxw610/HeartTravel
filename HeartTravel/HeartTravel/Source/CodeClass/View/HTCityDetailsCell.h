//
//  HTCityDetailsCell.h
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/20.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCityDetailsCell : UITableViewCell
/**
 *  景点图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
/**
 *  中文名
 */
@property (weak, nonatomic) IBOutlet UILabel *attractionName_cn;
/**
 *  英文名
 */
@property (weak, nonatomic) IBOutlet UILabel *attractionName;
/**
 *  评价
 */
@property (weak, nonatomic) IBOutlet UILabel *attractionScore;

@end
