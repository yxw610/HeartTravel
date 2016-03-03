//
//  HTCityStrategyCell.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/21.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTCityStrategyCell.h"
#import <UIImageView+WebCache.h>

@implementation HTCityStrategyCell

- (void)setModel:(HTCityStrategyModel *)model {
    
    self.topicLabel.text = model.topic;
    
    self.inspirationCountLabel.text = [NSString stringWithFormat:@"-%lu条旅行灵感-",model.inspiration_activities_count];
    
    [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:model.photo_url] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
