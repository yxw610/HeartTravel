//
//  HTTravelRecordPhotoCarouselViewController.h
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/18.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTPhotoContentCarouselFigureView;

@interface HTTravelRecordPhotoCarouselViewController : UIViewController

@property (assign, nonatomic) NSInteger defaultPage;

@property (strong, nonatomic) HTPhotoContentCarouselFigureView *carouselView;

@end
