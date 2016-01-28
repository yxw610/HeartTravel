//
//  HTPlacesViewController.m
//  HeartTravel
//
//  Created by 马浩杰 on 16/1/22.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTPlacesViewController.h"
#import "HJTableViewHeader.h"
#import "HJNavigationBar.h"
#import <UIImageView+WebCache.h>
#import <MDRadialProgressTheme.h>
#import <MDRadialProgressLabel.h>
#import <MDRadialProgressView.h>
#import "UIView+WLFrame.h"
#import "GetDataTools.h"
#import "HTPlacesModel.h"
#import "HTPlacesCell.h"
#import "HTScoreModel.h"

//屏幕尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kGap 10

@interface HTPlacesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) HJTableViewHeader* headView;
@property (nonatomic,strong) UIImageView* bigImageView;
@property (nonatomic,strong) UIView *scoreView;
@property (nonatomic,strong) NSMutableArray *scoreArray;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) CGFloat subViewX;
@property (nonatomic,strong) UILabel *titleLabel2;

@end

@implementation HTPlacesViewController

- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTableView];
    
    self.array = @[@"地址",@"门票",@"电话",@"开放时间",@"游玩时间",@"小贴士",@"星级",@"分类标签",@"菜系"];
    
    _bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.koubeilvxing.com/pics%@",self.backView]]];
    _bigImageView.clipsToBounds = YES;
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headView = [[HJTableViewHeader alloc]init];
    self.scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bigImageView.bottom, kScreenWidth, 150)];
    [_headView goodMenWithTableView:self.tableView andBackGroundView:_bigImageView andSubViews:_scoreView];
    [self getData];
    [self addScores];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavbarBackgroundHidden:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HTiconfont-fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction)];
}

- (void)addScores {
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    titleLabel1.text = self.titleName;
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel1.bottom, kScreenWidth, 30)];
    _titleLabel2.text = self.USName;
    [_titleLabel2 setFont:[UIFont systemFontOfSize:14]];
    _titleLabel2.textAlignment = NSTextAlignmentCenter;
    [self.scoreView addSubview:titleLabel1];
    [self.scoreView addSubview:_titleLabel2];
}

- (void)getData {
    
    [[GetDataTools shareGetDataTools] getDataWithUrlString:self.url data:^(NSDictionary *dataDict) {
        self.dataArray = [NSMutableArray array];
        HTPlacesModel *model = [HTPlacesModel new];
        [model setValuesForKeysWithDictionary:dataDict[@"item"]];
        [self.dataArray addObject:model];
        
        self.scoreArray = [NSMutableArray array];
        for (NSDictionary *dict in dataDict[@"item"][@"dimensionScores"]) {
            HTScoreModel *model = [HTScoreModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.scoreArray addObject:model];
        }
        
        self.dataArr = self.array.mutableCopy;
        for (NSString *str in self.array) {
            if ([str isEqualToString:@"地址"]) {
                if (model.address.length == 0) {
                    [self.dataArr removeObject:str];
                }
            }
            if ([str isEqualToString:@"门票"]) {
                if (model.priceinfo.length == 0) {
                    [self.dataArr removeObject:str];
                }
            }
            
            if ([str isEqualToString:@"电话"]) {
                if (model.contact.length == 0) {
                    [self.dataArr removeObject:str];
                }
            }
            
            if ([str isEqualToString:@"开放时间"]) {
                if (model.opening_time.length == 0) {
                    [self.dataArr removeObject:str];
                }
            }
            
            if ([str isEqualToString:@"游玩时间"]) {
                if (model.duration.length == 0) {
                    [self.dataArr removeObject:str];
                }
            }
            
            if ([str isEqualToString:@"小贴士"]) {
                if (model.tip.length == 0) {
                    [self.dataArr removeObject:str];
                }
            }
            
            if ([str isEqualToString:@"星级"]) {
                if (model.star.length == 0) {
                    [self.dataArr removeObject:str];
                }
            }
            
            if ([str isEqualToString:@"分类标签"]) {
                if (model.tag_cn.length == 0) {
                    [self.dataArr removeObject:str];
                }
            }
            
            if ([str isEqualToString:@"菜系"]) {
                if (model.cuisines_cn.length == 0) {
                    [self.dataArr removeObject:str];
                }
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addScore];
            [self.tableView reloadData];
        });
    }];
}

- (void)addScore {
    NSInteger sCount = self.scoreArray.count;
    CGFloat subViewW = 50;
    CGFloat subViewH = 50;
    if (sCount % 2 == 0) {
        for (int i = 0; i < sCount; i++) {
            if (i < sCount / 2) {
                CGFloat subViewX = kScreenWidth / 2 - (sCount / 2 - i) * kGap - (sCount / 2 - i) * subViewW + kGap / 2;
                MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(subViewX, _titleLabel2.bottom, subViewW, subViewH)];
                HTScoreModel *model = self.scoreArray[i];
                radialView.progressTotal = 10;
                radialView.progressCounter = model.score.integerValue;
                radialView.label.text = [NSString stringWithFormat:@"%@分",[model.score substringToIndex:1]];
                radialView.label.font = [UIFont systemFontOfSize:12];
                radialView.theme.sliceDividerHidden = YES;
                [self.scoreView addSubview:radialView];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subViewX, radialView.bottom, subViewW, 20)];
                titleLabel.text = model.name;
                titleLabel.font = [UIFont systemFontOfSize:13];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [self.scoreView addSubview:titleLabel];
            } else {
                CGFloat subViewX = kScreenWidth / 2 + kGap + (i - sCount / 2) * kGap + (i - sCount / 2) * subViewW - kGap / 2;
                MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(subViewX, _titleLabel2.bottom, subViewW, subViewH)];
                HTScoreModel *model = self.scoreArray[i];
                radialView.progressTotal = 10;
                radialView.progressCounter = model.score.integerValue;
                radialView.label.text = [NSString stringWithFormat:@"%@分",[model.score substringToIndex:1]];
                radialView.label.font = [UIFont systemFontOfSize:12];
                radialView.theme.sliceDividerHidden = YES;
                [self.scoreView addSubview:radialView];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subViewX, radialView.bottom, subViewW, 20)];
                titleLabel.text = model.name;
                titleLabel.font = [UIFont systemFontOfSize:13];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [self.scoreView addSubview:titleLabel];
            }
        }
    } else {
        for (int i = 0; i < sCount; i++) {
            if (i < sCount / 2 + 1) {
                CGFloat subViewX = kScreenWidth / 2 - subViewW / 2 - (sCount / 2 - i) * kGap - (sCount / 2 - i) * subViewW;
                MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(subViewX, _titleLabel2.bottom, subViewW, subViewH)];
                HTScoreModel *model = self.scoreArray[i];
                radialView.progressTotal = 10;
                radialView.progressCounter = model.score.integerValue;
                radialView.label.text = [NSString stringWithFormat:@"%@分",[model.score substringToIndex:1]];
                radialView.label.font = [UIFont systemFontOfSize:12];
                radialView.theme.sliceDividerHidden = YES;
                [self.scoreView addSubview:radialView];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subViewX, radialView.bottom, subViewW, 20)];
                titleLabel.text = model.name;
                titleLabel.font = [UIFont systemFontOfSize:13];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [self.scoreView addSubview:titleLabel];
                
            } else {
                CGFloat subViewX = kScreenWidth / 2 + subViewW / 2 + (i - sCount / 2) * kGap + (i - sCount / 2 - 1) * subViewW;
                MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(subViewX, _titleLabel2.bottom, subViewW, subViewH)];
                HTScoreModel *model = self.scoreArray[i];
                radialView.progressTotal = 10;
                radialView.progressCounter = model.score.integerValue;
                radialView.label.text = [NSString stringWithFormat:@"%@分",[model.score substringToIndex:1]];
                radialView.label.font = [UIFont systemFontOfSize:12];
                radialView.theme.sliceDividerHidden = YES;
                [self.scoreView addSubview:radialView];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subViewX, radialView.bottom, subViewW, 20)];
                titleLabel.text = model.name;
                titleLabel.font = [UIFont systemFontOfSize:13];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [self.scoreView addSubview:titleLabel];
                
            }
        }
        
    }
}

- (void)leftButtonAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setNavbarBackgroundHidden:(BOOL)hidden {
    
    HJNavigationBar *navBar = (HJNavigationBar *)self.navigationController.navigationBar;
    if (!hidden) {
        [navBar show];
    } else {
        [navBar hidden];
    }
    
}

- (void)getTableView {
    
    [self.view addSubview: self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HTPlacesCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTPlacesCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *str = self.dataArr[indexPath.row];
    cell.titleName.text = str;
    if ([str isEqualToString:@"地址"]) {
        
        return 80;
    }
    if ([str isEqualToString:@"门票"]) {
        
        return 50;
    }
    
    if ([str isEqualToString:@"电话"]) {
        
        return 50;
    }
    
    if ([str isEqualToString:@"开放时间"]) {
        
        return 70;
    }
    
    if ([str isEqualToString:@"游玩时间"]) {
        
        return 50;
    }
    
    if ([str isEqualToString:@"小贴士"]) {
        
        return cell.detailedLabel.height;
    }
    
    if ([str isEqualToString:@"星级"]) {
        
        return 50;
    }
    
    if ([str isEqualToString:@"分类标签"]) {
        
        return 60;
    }
    
    if ([str isEqualToString:@"菜系"]) {
        
    }
    
    return 50;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTPlacesCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    HTPlacesModel *model = self.dataArray.firstObject;
    NSString *str = self.dataArr[indexPath.row];
    cell.titleName.text = str;
    if ([str isEqualToString:@"地址"]) {
        cell.detailedLabel.text = model.address;
    }
    if ([str isEqualToString:@"门票"]) {
        cell.detailedLabel.text = model.priceinfo;
    }
    
    if ([str isEqualToString:@"电话"]) {
        cell.detailedLabel.text = model.contact;
    }
    
    if ([str isEqualToString:@"开放时间"]) {
        cell.detailedLabel.text = model.opening_time;
    }
    
    if ([str isEqualToString:@"游玩时间"]) {
        cell.detailedLabel.text = model.duration;
    }
    
    if ([str isEqualToString:@"小贴士"]) {
        cell.detailedLabel.text = model.tip;
    }
    
    if ([str isEqualToString:@"星级"]) {
        cell.detailedLabel.text = model.star;
    }
    
    if ([str isEqualToString:@"分类标签"]) {
        cell.detailedLabel.text = model.tag_cn;
    }
    
    if ([str isEqualToString:@"菜系"]) {
        cell.detailedLabel.text = model.cuisines_cn;
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_headView scrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y < self.bigImageView.frame.size.height - 64) {
        [self setNavbarBackgroundHidden:YES];
    } else {
        [self setNavbarBackgroundHidden:NO];
    }
}
@end
