//
//  HTTravelRecordTableViewCell.m
//  HTTravelRecord
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTTravelRecordTableViewCell.h"
#import "HTTravelRecordModel.h"
#import "HTUserModel.h"
#import "HTRecordContentModel.h"
#import "UIImageView+WebCache.h"
#import "HTPhotoContentCarouselFigureView.h"
#import "HTTravelRecordTableViewController.h"
#import "HTTravelRecordPhotoCarouselViewController.h"
#import "HTDistrictModel.h"
#import "HTLoginViewController.h"
#import <AVOSCloud.h>
#import "GetUser.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kRecordContentViewHeight (kScreenWidth * 3 / 8)

#define kFavoriteRecord @"FavoriteRecord"
#define kFavoriteInfo @"FavoriteInfo"

typedef NS_ENUM(NSInteger, HTFavoriteStyle) {
    HTFavoriteStyleURL,
    HTFavoriteStyleLocation,
};


@interface HTTravelRecordTableViewCell ()

/**
 *  游记View
 */
@property (weak, nonatomic) IBOutlet UIView *recordContentView;

/**
 *  封面图片View的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicImgViewHeightConstraint;

/**
 *  游记View的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordContentViewHeightConstraint;

/**
 *  游记标题Label的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordTopicLabelHeightConstraint;

/**
 *  游记内容Label到父视图底部的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordContentLabelConstraintToRecordContentViewBottom;

@property (assign, nonatomic) NSInteger favoriteCount;

@property (assign, nonatomic) BOOL addORNo;

@property (assign, nonatomic) HTFavoriteStyle favoriteStyle;


@end

@implementation HTTravelRecordTableViewCell

- (void)awakeFromNib {
    
    // 用户头像切圆
    self.userImgView.layer.cornerRadius = self.userImgView.frame.size.height / 2;
    self.userImgView.layer.masksToBounds = YES;

}


/**
 *  给cell赋值方法
 *
 *  @param model model对象
 */
- (void)setCellValueWithModel:(HTTravelRecordModel *)model imgViewHeight:(CGFloat)imgViewHeight recordContentViewHeight:(CGFloat)recordContentViewHeight{
    
    self.addORNo = YES;
    
    self.model = model;
    
    // 设置用户信息
    self.userNameLabel.text = model.userInfo.name;
    [self.userImgView sd_setImageWithURL:[NSURL URLWithString:model.userInfo.photo_url]];
    
    // 设置图片信息
    self.topicImgViewHeightConstraint.constant = imgViewHeight;
//    UIProgressView *pv = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    [self.topicImgView sd_setImageWithURL:[NSURL URLWithString:((HTRecordContentModel *)model.contents[0]).photo_url] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] options:(SDWebImageCacheMemoryOnly) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
//        pv.frame = CGRectMake(0, 0, CGRectGetWidth(self.topicImgView.frame)/2, 50);
//        pv.center = self.topicImgView.center;
//        [self.topicImgView addSubview:pv];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
//        [pv removeFromSuperview];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapActionInTopicImageView:)];
    self.topicImgView.userInteractionEnabled = YES;
    [self.topicImgView addGestureRecognizer:tap];
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:model.contents];
    [imageArray removeObjectAtIndex:0];
    
    if (self.carouselView.subviews) {
        
        for (HTPhotoContentCarouselFigureView *view in self.carouselView.subviews) {
            
            [view removeFromSuperview];
        }
    }
    
    UITapGestureRecognizer *favoriteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteOrNoAction:)];
    self.favoriteImgView.userInteractionEnabled = YES;
    [self.favoriteImgView addGestureRecognizer:favoriteTap];

    
    [self drawScrollViewWithImages:imageArray];
    
    
    
    NSArray *heightArray = [HTTravelRecordTableViewCell caculateHeightForLabelWithModel:model];
    
    self.recordContentViewHeightConstraint.constant = recordContentViewHeight + 5;
    
    self.recordTopicLabelHeightConstraint.constant = [heightArray[0] floatValue];
    
    if (recordContentViewHeight != kRecordContentViewHeight) {
        
        self.recordContentLabelConstraintToRecordContentViewBottom.constant = 0;
    } else {
        
        self.recordContentLabelConstraintToRecordContentViewBottom.constant = 25;
    }
    
    self.recordTopicLabel.text = model.topic;
    self.recordContentLabel.text = model.desc;
    
    HTDistrictModel *districtModel = model.districts[0];
    NSMutableString *districtString = [NSMutableString stringWithFormat:@"%@",districtModel.name];
    
    GetUser *user = [GetUser shareGetUser];
    
    if (model.districts.count > 0) {
        
        for (int i = 1; i < model.districts.count; i++ ) {
            
            HTDistrictModel *tempModel = model.districts[i];
            [districtString appendFormat:@",%@",tempModel.name];
        }
        
        self.districts.text = districtString;
    }
    
    if (model.groupNum == 0 && user != nil) {
        
        AVQuery *query = [AVQuery queryWithClassName:@"URLRecord"];
        [query whereKey:@"model_id" equalTo:@(model.model_id)];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            AVObject *record = [objects firstObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.favoriteCount = [record[@"favorites_count"] integerValue];
                self.favoriteCountLabel.text = [record[@"favorites_count"] stringValue];
            });
            
        }];
        
        
        AVQuery *favoriteQuery = [AVQuery queryWithClassName:kFavoriteRecord];
        [favoriteQuery whereKey:@"model_id" equalTo:@(model.model_id)];
        [favoriteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            for (AVObject *object in objects) {
                
                if ([object[@"user_id"] integerValue] == user.user_id) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.addORNo = NO;
                        self.favoriteImgView.image = [UIImage imageNamed:@"dianzan-yes"];
                    });
                }
            }
        }];
        
    } else if(model.groupNum == 0 && user != nil){
        
        AVQuery *query = [AVQuery queryWithClassName:@"TravelRecord"];
        [query whereKey:@"model_id" equalTo:@(model.model_id)];
        NSArray *array = [query findObjects];
        AVObject *record = [array firstObject];
        self.favoriteCount = [record[@"favorites_count"] integerValue];
        self.favoriteCountLabel.text = [record[@"favorites_count"] stringValue];
        
        AVQuery *favoriteQuery = [AVQuery queryWithClassName:kFavoriteInfo];
        [favoriteQuery whereKey:@"model_id" equalTo:@(model.model_id)];
        [favoriteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            for (AVObject *object in objects) {
                
                if ([object[@"user_id"] integerValue] == user.user_id) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.addORNo = NO;
                        self.favoriteImgView.image = [UIImage imageNamed:@"dianzan-yes"];
                    });
                }
            }
        }];
    }
    else if (model.groupNum == 1 && user == nil) {
        
        AVQuery *query = [AVQuery queryWithClassName:@"TravelRecord"];
        [query whereKey:@"model_id" equalTo:@(model.model_id)];
        NSArray *array = [query findObjects];
        AVObject *record = [array firstObject];
        self.favoriteCount = [record[@"favorites_count"] integerValue];
        self.favoriteCountLabel.text = [record[@"favorites_count"] stringValue];
        self.favoriteImgView.image = [UIImage imageNamed:@"dianzan-no"];
    } else  {
        
        AVQuery *query = [AVQuery queryWithClassName:@"URLRecord"];
        [query whereKey:@"model_id" equalTo:@(model.model_id)];
        NSArray *array = [query findObjects];
        AVObject *record = [array firstObject];
        self.favoriteCount = [record[@"favorites_count"] integerValue];
        self.favoriteCountLabel.text = [record[@"favorites_count"] stringValue];
        self.favoriteImgView.image = [UIImage imageNamed:@"dianzan-no"];
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  显示全部文本
 *
 *  @param sender button
 */
- (IBAction)showWholeRecordAction:(id)sender {
    
    self.showWholeRecordBlock(self);
    
}

/**
 *  计算文本的高度
 *
 *  @param model 需要计算的model
 *
 *  @return 标题高度与文本高度的集合
 */
+ (NSArray *)caculateHeightForLabelWithModel:(HTTravelRecordModel *)model {
    
    NSMutableArray *heightArray = [NSMutableArray array];
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize topicSize = [model.topic boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 10000) options:option attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    if (topicSize.height <= 20) {
        topicSize.height = 20;
    } else {
        topicSize.height = 40;
    }
    [heightArray addObject:@(topicSize.height)];
    
    CGSize contentSize = [model.desc boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 10000) options:option attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    [heightArray addObject:@(contentSize.height)];
    
    CGFloat totalHeight = contentSize.height + topicSize.height;
    
    if (totalHeight > kRecordContentViewHeight - 25) {
        
        totalHeight = kRecordContentViewHeight;
    }
    
    [heightArray addObject:@(totalHeight)];
    
    return heightArray;
}

#define kGap 5
#define kImgViewHeight ((kScreenWidth / 4) - 2 * kGap)
#define kImgViewWidth (kImgViewHeight * 2)


- (void)drawScrollViewWithImages:(NSMutableArray *)images {
        
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.carouselView.bounds];
    
    scrollView.bounces = NO;
    scrollView.pagingEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake((kImgViewWidth + kGap) * images.count + kGap, kImgViewHeight + 2 * kGap);

    // 添加图片视图
    for (int i = 0; i < images.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kImgViewWidth * i + kGap * (i + 1), kGap, kImgViewWidth, kImgViewHeight)];
        
        HTRecordContentModel *model = images[i];

//        UIProgressView *pv = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:model.photo_url] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] options:(SDWebImageCacheMemoryOnly) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
//            pv.frame = CGRectMake(0, 0, CGRectGetWidth(imgView.frame)/2, 50);
//            pv.center = imgView.center;
//            NSLog(@"%d,%lf,%lf,%lf,%lf",i,pv.frame.origin.x,pv.frame.origin.y,pv.frame.size.width,pv.frame.size.height);
//            [imgView addSubview:pv];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
//            [pv removeFromSuperview];
        }];
        imgView.userInteractionEnabled = YES;
        imgView.tag = 1000 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapActionInImageView:)];
        [imgView addGestureRecognizer:tap];
        
        [scrollView addSubview:imgView];
    }
    
    [self.carouselView addSubview:scrollView];
}

#pragma mark -- Tap 手势 --
/**
 *  点击轮播图片
 *
 *  @param tap tap手势
 */
- (void)handleTapActionInImageView:(UITapGestureRecognizer *)tap {
    
    // 获取点击的视图
    UIImageView *imgView = (UIImageView *)tap.view;
    NSInteger index = imgView.tag - 1000;
    
    HTTravelRecordPhotoCarouselViewController *carouselViewController = [[HTTravelRecordPhotoCarouselViewController alloc] init];
    NSMutableArray *imgArray = [self.model.contents mutableCopy];
    carouselViewController.carouselView.defaultPage = index+1;
    carouselViewController.carouselView.images = imgArray;

    HTTravelRecordTableViewController *viewController = (HTTravelRecordTableViewController *)self.superview.superview.nextResponder;

    [viewController presentViewController:carouselViewController animated:YES completion:nil];
}

/**
 *  点击封面图片
 *
 *  @param tap tap手势
 */
- (void)handleTapActionInTopicImageView:(UITapGestureRecognizer *)tap {
    
    HTTravelRecordPhotoCarouselViewController *carouselViewController = [[HTTravelRecordPhotoCarouselViewController alloc] init];
    NSMutableArray *imgArray = [self.model.contents mutableCopy];
    carouselViewController.carouselView.defaultPage = 0;
    carouselViewController.carouselView.images = imgArray;
    
    HTTravelRecordTableViewController *viewController = (HTTravelRecordTableViewController *)self.superview.superview.nextResponder;
    
    [viewController presentViewController:carouselViewController animated:YES completion:nil];
}

/**
 *  点赞
 *
 *  @param tap tap手势
 */

- (void)favoriteOrNoAction:(UITapGestureRecognizer *)tap {
    NSLog(@"favoriteOrNoAction");
    
    AVUser *user = [AVUser currentUser];
    if (user == nil) {
        
        
    } else {
        
        GetUser *user = [GetUser shareGetUser];
        
        if (self.model.groupNum == 0) {
            self.favoriteStyle = HTFavoriteStyleURL;
            if (self.addORNo == YES) {
                
                self.addORNo = NO;
                self.favoriteCount += 1;
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld",self.favoriteCount];
                self.favoriteImgView.image = [UIImage imageNamed:@"dianzan-yes"];
                
                self.favoriteCountBlock(self.favoriteCount,0,self.model.model_id,YES);
            } else {
                self.addORNo = YES;
                self.favoriteCount -= 1;
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld",self.favoriteCount];
                self.favoriteImgView.image = [UIImage imageNamed:@"dianzan-no"];
                self.favoriteCountBlock(self.favoriteCount,0,self.model.model_id,NO);
            }
            
        } else {
            self.favoriteStyle = HTFavoriteStyleLocation;
            if (self.addORNo == YES) {
                self.addORNo = NO;
                self.favoriteCount += 1;
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld",self.favoriteCount];
                self.favoriteImgView.image = [UIImage imageNamed:@"dianzan-yes"];
                self.favoriteCountBlock(self.favoriteCount,1,self.model.model_id,YES);
            } else {
                self.addORNo = YES;
                self.favoriteCount -= 1;
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld",self.favoriteCount];
                self.favoriteImgView.image = [UIImage imageNamed:@"dianzan-no"];
                self.favoriteCountBlock(self.favoriteCount,1,self.model.model_id,NO);
            }
        }
        
    }
}

/*
- (void)favoriteOrNoAction:(UITapGestureRecognizer *)tap {

    NSLog(@"favoriteOrNoAction");
    
    AVUser *user = [AVUser currentUser];
    if (user == nil) {
        
        
    } else {
        
        GetUser *user = [GetUser shareGetUser];
   
        if (self.model.groupNum == 0) {
            
            AVQuery *query = [AVQuery queryWithClassName:kFavoriteRecord];
            [query whereKey:@"user_id" equalTo:@(user.user_id)];
            
            __unsafe_unretained typeof(self) weakSelf = self;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (objects.count == 0) {
                    
                    [weakSelf addFavoriteCount:kFavoriteRecord];

                } else {
                    
                    NSInteger i = 0;
                    
                    for (AVObject *object in objects) {
                        
                        if ([object[@"model_id"] integerValue] == self.model.model_id) {
                            
                            i = 1;
                            [weakSelf removeFavoriteCount:kFavoriteRecord];

                        }
                    }
                    if (i == 0) {
                        [weakSelf addFavoriteCount:kFavoriteRecord];
                    }
                }
            }];

        } else {
            
            AVQuery *query = [AVQuery queryWithClassName:kFavoriteInfo];
            [query whereKey:@"user_id" equalTo:@(user.user_id)];
            __unsafe_unretained typeof(self) weakSelf = self;
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (objects.count == 0) {
                    
                    [weakSelf addFavoriteCount:kFavoriteInfo];

                } else {
                    
                    NSInteger i = 0;
                    
                    for (AVObject *object in objects) {
                        
                        if ([object[@"model_id"] integerValue] == self.model.model_id) {
                            
                            i = 1;
                            [weakSelf removeFavoriteCount:kFavoriteInfo];

                        }
                    }
                    if (i == 0) {
                        [weakSelf addFavoriteCount:kFavoriteInfo];

                    }
                }
            }];

        }
    }
    
}
 */

/**
 *  收藏
 */
- (void)addFavoriteCount:(NSString *)className {
    
    self.favoriteImgView.image = [UIImage imageNamed:@"dianzan-yes"];
    GetUser *user = [GetUser shareGetUser];
    
    AVObject *favoriteRecord = [AVObject objectWithClassName:className];
    favoriteRecord[@"user_id"] = @(user.user_id);
    favoriteRecord[@"model_id"] = @(self.model.model_id);
    
    [favoriteRecord saveInBackground];
    
    if ([className isEqualToString:kFavoriteRecord]) {
        
        AVQuery *query = [AVQuery queryWithClassName:@"URLRecord"];
        [query whereKey:@"model_id" equalTo:@(self.model.model_id)];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            AVObject *record = [objects firstObject];
            NSInteger favorites_count = [record[@"favorites_count"] integerValue];
            favorites_count += 1;
            
            record[@"favorites_count"] = @(favorites_count);
            [record saveInBackground];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld",favorites_count];
            });
            
        }];
        
    } else {
        
        AVQuery *query = [AVQuery queryWithClassName:@"TravelRecord"];
        [query whereKey:@"model_id" equalTo:@(self.model.model_id)];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            AVObject *record = [objects firstObject];
            NSInteger favorites_count = [record[@"favorites_count"] integerValue];
            favorites_count += 1;
            
            record[@"favorites_count"] = @(favorites_count);
            [record saveInBackground];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld",favorites_count];
            });
            
        }];
    }
}

/**
 *  取消收藏
 */
- (void)removeFavoriteCount:(NSString *)className {
    
    self.favoriteImgView.image = [UIImage imageNamed:@"dianzan-no"];
    
    GetUser *user = [GetUser shareGetUser];
    
    AVQuery *deleteQuery = [AVQuery queryWithClassName:className];
    [deleteQuery whereKey:@"user_id" equalTo:@(user.user_id)];
    [deleteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (AVObject *object in objects) {
            
            if ([object[@"model_id"] integerValue] == self.model.model_id) {
                
                [object deleteInBackground];
            }
        }
    }];
    
    if ([className isEqualToString:kFavoriteRecord]) {
        
        AVQuery *query = [AVQuery queryWithClassName:@"URLRecord"];
        [query whereKey:@"model_id" equalTo:@(self.model.model_id)];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            AVObject *record = [objects firstObject];
            NSInteger favorites_count = [record[@"favorites_count"] integerValue];
            if (favorites_count > 0) {
                
                favorites_count -= 1;
            }
            
            
            record[@"favorites_count"] = @(favorites_count);
            [record saveInBackground];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld",favorites_count];
            });
            
        }];
        
    } else {
        
        AVQuery *query = [AVQuery queryWithClassName:@"TravelRecord"];
        [query whereKey:@"model_id" equalTo:@(self.model.model_id)];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            AVObject *record = [objects firstObject];
            NSInteger favorites_count = [record[@"favorites_count"] integerValue];
            favorites_count -= 1;
            
            record[@"favorites_count"] = @(favorites_count);
            [record saveInBackground];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld",favorites_count];
            });
            
        }];
    }
}


@end
