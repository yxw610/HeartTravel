//
//  HTDiscoverDetailCell.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTDestinationStrategyCell.h"
#import <UIImageView+WebCache.h>

@implementation HTDestinationStrategyCell

- (void)setDetail:(HTDestinationStrategy *)detail {
    self.detailNameLabel.text = detail.name;
    self.inspirationLabel.text = [NSString stringWithFormat:@"%lu条旅行灵感",detail.inspiration_activities_count];
    [self.detailImgView sd_setImageWithURL:[NSURL URLWithString:detail.photo_url] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //DestinationStrategy
    // Configure the view for the selected state
}

@end
