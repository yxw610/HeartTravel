//
//  HTDiscoveryHotCell.h
//  HeartTravel
//
//  Created by lanou3g on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTDiscoveryHot.h"

@interface HTDiscoveryHotCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishNameLabel;

@property (strong, nonatomic)HTDiscoveryHot *discoveryHot;

@end
