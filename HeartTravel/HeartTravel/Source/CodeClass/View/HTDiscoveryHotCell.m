//
//  HTDiscoveryHotCell.m
//  HeartTravel
//
//  Created by lanou3g on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTDiscoveryHotCell.h"
#import <UIImageView+WebCache.h>

@implementation HTDiscoveryHotCell

- (void)awakeFromNib {
    // 图片切圆
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 5;
}
- (void)setDiscoveryHot:(HTDiscoveryHot *)discoveryHot {
    self.nameLabel.text = discoveryHot.name;
    self.englishNameLabel.text = discoveryHot.name_en;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:discoveryHot.photo_url]];
}

@end
