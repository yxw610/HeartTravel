//
//  HTTurnInfoViewController.m
//  ChouTi
//
//  Created by 史丽娜 on 16/1/27.
//  Copyright © 2016年 史丽娜. All rights reserved.
//

#import "HTTurnInfoViewController.h"
#import <Masonry/Masonry.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HTUserModel.h"
#import "GetUser.h"
#import "UIImageView+WebCache.h"
#import <MBProgressHUD.h>
#import "GetUser.h"
#import "HTLoginViewController.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kBackH kWidth / 2

#define kLeftGap kWidth / 8
#define kGap kHeight / 20
#define kHeadWidth 70
#define kHeadHeight 70



@interface HTTurnInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>


@property (nonatomic,strong)UIImageView *headImg;

@end

@implementation HTTurnInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人修改";
    
    UIImage * normalImg = [UIImage imageNamed:@"iconfont-iconfanhui-2"];
    normalImg = [normalImg imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:normalImg style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    
    UIImage * norImg = [UIImage imageNamed:@"iconfont-queren"];
    norImg = [norImg imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:norImg style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self drawView];
}


- (void)drawView {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64,kWidth, kBackH)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"9.jpg"]];
 
    // 用户信息
    GetUser *userInfo = [GetUser shareGetUser];
    
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth / 2.45, kBackH /4.5, kHeadWidth, kHeadHeight)];
    
    if ([userInfo.photo_url isEqualToString:@""] || userInfo.photo_url == nil) {
        
        _headImg.image=[UIImage imageNamed:@"iconfont-unie64d"];
    } else {
        
        [_headImg sd_setImageWithURL:[NSURL URLWithString:userInfo.photo_url] placeholderImage:[UIImage imageNamed:@"HTLeftMenu_Head"]];
    }
    _headImg.layer.cornerRadius = 35;
    _headImg.layer.masksToBounds = YES;
    _headImg.userInteractionEnabled = YES;
    
    [headerView addSubview:_headImg];
    
    //添加手势
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topPictureAction:)];
    [_headImg addGestureRecognizer:tap];
    
    [self.view addSubview:headerView];
    
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kGap, kBackH * 1.3 , 5*kGap , 3*kGap)];
    _nameLabel.text = @"昵称:";
    [self.view addSubview:_nameLabel];

    
    _genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(kGap, kBackH * 1.6 , 5 *kGap , 3* kGap)];
    _genderLabel.text = @"性别:";
    [self.view addSubview:_genderLabel];
    
    _nameText = [[UITextField alloc]initWithFrame:CGRectMake(2.5 * kGap, kBackH *1.45, 8 * kGap, 1.4 * kGap)];
    //_nameText.backgroundColor = [UIColor redColor];
    [self.view addSubview:_nameText];
    
    _genderText = [[UITextField alloc]initWithFrame:CGRectMake(2.5 * kGap, kBackH * 1.75, 8 * kGap, 1.4 * kGap)];
   // _genderText.backgroundColor = [UIColor redColor];
    [self.view addSubview:_genderText];
    

    
    
}


- (void)rightAction:(UIBarButtonItem *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.labelText = @"正在修改...";
    
    GetUser *user = [GetUser shareGetUser];
    
    AVQuery * querry = [AVQuery queryWithClassName:@"UserInfo"];
    [querry whereKey:@"user_id" equalTo:@(user.user_id)];

    AVObject *object = [querry findObjects].firstObject;
    
    if ([_nameText.text isEqualToString:@""] || _nameText.text == nil) {
        
    } else {
        [object setObject:_nameText.text forKey:@"name"];
    }

    if ([_genderLabel.text isEqualToString:@"男"]) {
        [object setObject:@(1) forKey:@"gender"];
    } else {
        [object setObject:@(0) forKey:@"gender"];
    }
    
    
    NSData * data = UIImagePNGRepresentation(_headImg.image);
    AVFile * file =[AVFile fileWithName:@"avatar.png" data:data];
    if ([file save]) {
        [object setObject:file.url forKey:@"photo_url"];
    }
 
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
          {
              
        if (succeeded) {
            
            [hud hide:YES];
            GetUser *user = [GetUser shareGetUser];
            [user updateUserInfo];
            [self showSuccessAlert];
            
        } else {
            
            [hud hide:YES];
            [self showFailAlert];
        }
    }];

}

- (void)showSuccessAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self.delegate changeUserInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)showFailAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)leftAction:(UIBarButtonItem *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)topPictureAction:(UITapGestureRecognizer *)sender
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil  preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //判断是否可以打开相机，模拟器此功能无法使用
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            
            //调用系统照相机
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            //是否可编辑
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];


        }else
        {
            //如果没有提示用户
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
            [alert show];
        }
        
        
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //相册是可以用模拟器打开的
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            //打开相册选择照片
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
   


        }else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"你没有照片" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
            [alert show];
        }
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:takePhotoAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
//选中图片进入的代理方法
//拍摄完成后要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    UIImage *headerImg = info[UIImagePickerControllerEditedImage];
    headerImg = [self imageCompressForWidth:headerImg targetWidth:100];
    _headImg.image = headerImg;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 压缩图片
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -----------MBProgressHUD代理实现----------------
- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    [hud removeFromSuperview];
    hud = nil;
}
@end