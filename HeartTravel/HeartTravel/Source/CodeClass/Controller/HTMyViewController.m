//
//  HTMyViewController.m
//  ChouTi
//
//  Created by 史丽娜 on 16/1/26.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import "HTMyViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <RESideMenu/RESideMenu.h>
#import "QYTableViewHeader.h"
#import "HTTurnInfoViewController.h"
#import "HTHomeViewController.h"
#import "HTRegisteViewController.h"
#import "HTLoginViewController.h"
#import "GetUser.h"
#import "UIImageView+WebCache.h"
#import "HTFavoriteRecordTableViewController.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kBackH kWidth/1.5

@interface HTMyViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)QYTableViewHeader *headView;
@property (nonatomic,strong)UIImageView *bigImageView;
@property (nonatomic,strong)UIImageView *smallView;

@end

@implementation HTMyViewController
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return  _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self getTableView];
    
    UIImage *normalImg = [UIImage imageNamed:@"HTHome_Menu"];
    normalImg = [normalImg imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:normalImg style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];

    
    //头部背景图
    _bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kWidth, kBackH)];
    _bigImageView.image = [UIImage imageNamed:@"9.jpg"];
     _bigImageView.clipsToBounds=YES;
    _bigImageView.userInteractionEnabled = YES;
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // 用户信息
    GetUser *userInfo = [GetUser shareGetUser];
    //头像
    
    _smallView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    if ([userInfo.photo_url isEqualToString:@""] || userInfo.photo_url == nil) {
        
        _smallView.image=[UIImage imageNamed:@"iconfont-unie64d"];
    } else {
        
        [_smallView sd_setImageWithURL:[NSURL URLWithString:userInfo.photo_url] placeholderImage:[UIImage imageNamed:@"HTLeftMenu_Head"]];
    }
   
    _smallView.center=CGPointMake(_bigImageView.center.x, _bigImageView.center.y);
    _smallView.clipsToBounds=YES;
   _smallView.contentMode=UIViewContentModeScaleAspectFill;
    _smallView.userInteractionEnabled = YES;
    _smallView.layer.cornerRadius = 35;
    _smallView.layer.masksToBounds =YES;
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    //
    [_smallView addGestureRecognizer:tap];
    
    _headView=[[QYTableViewHeader alloc]init];
    
    [_headView goodMenWithTableView:self.tableView andBackGroundView:_bigImageView andSubviews:_smallView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
-(void)getTableView
{
    [self.view addSubview: self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}


#pragma mark-----------tableView的代理方法-----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
   NSArray *array = @[@"修改资料",@"我的收藏",@"退出账户"];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = array[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
       if (indexPath.row == 0) {
        
        
        HTTurnInfoViewController *turnVC = [[HTTurnInfoViewController alloc]init];
        [self.navigationController pushViewController:turnVC animated:YES];
        
    } else if(indexPath.row == 1){

        HTFavoriteRecordTableViewController *favoriteRecordTVC = [[HTFavoriteRecordTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
        [self.navigationController pushViewController:favoriteRecordTVC animated:YES];
    
    }else
    {
       
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否退出登陆" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            //判断它是否登陆
            AVUser *currentUser = [AVUser currentUser];
            if (currentUser != nil) {
            
                [AVUser logOut];

                [self.delegate changeLoginState];
                [self.sideMenuViewController presentLeftMenuViewController];
                                    
            }

        }];
    
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        
          [self presentViewController:alert animated:YES completion:nil];

    }
    
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headView scrollViewDidScroll:scrollView];
    
}
-(void)viewDidLayoutSubviews
{
    [_headView resizeView];
}

#pragma mark---------------头像添加手势的触发事件--------------
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    HTTurnInfoViewController *turnVC = [[HTTurnInfoViewController alloc]init];
    
    //UINavigationController *turnNC = [[UINavigationController alloc]initWithRootViewController:turnVC];
    
    [self.navigationController pushViewController:turnVC animated:YES];

}
#pragma mark--------------左按钮的点击事件----------------
- (void)leftAction:(UIBarButtonItem *)sender
{
  
    [self.sideMenuViewController presentLeftMenuViewController];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
