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

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kBackH kWidth / 2

#define kLeftGap kWidth / 8
#define kGap kHeight / 20
#define kHeadWidth 70
#define kHeadHeight 70



@interface HTTurnInfoViewController ()<UITableViewDelegate,
UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIImageView *headImg;

//@property (nonatomic,strong) HTTurnInfoTableViewCell *cell;
@end

@implementation HTTurnInfoViewController

//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//    }
//    return  _tableView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    //       [self getTableView];
    
    UIImage * normalImg = [UIImage imageNamed:@"iconfont-iconfanhui-2"];
    normalImg = [normalImg imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:normalImg style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    
    UIImage * norImg = [UIImage imageNamed:@"iconfont-queren"];
    norImg = [norImg imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:norImg style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction:)];
    
    [self drawView];
}



- (void)drawView {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64,kWidth, kBackH)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"9.jpg"]];
 
    
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth / 2.45, kBackH /4.5, kHeadWidth, kHeadHeight)];
    _headImg.image = [UIImage imageNamed:@"iconfont-unie64d"];
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
    
//    
//    NSData *imageData = UIImagePNGRepresentation(_headImg.image);
//    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
//   
//    AVObject *userPost = [AVObject objectWithClassName:@"UserInfo"];
//    [userPost setObject:@"My trip to Dubai!" forKey:@"content"];
//    [userPost setObject:imageFile            forKey:@"avatar"];
//    [userPost saveInBackground];
//    
//    if (_nameText.text.length !=0) {
//        AVUser *currentuser = [AVUser currentUser];
//        [currentuser objectForKey:@"user_id"];
//        AVObject *userInfo = [AVObject objectWithClassName:@"UserInfo"];
//        [userInfo setObject:@"用户ID" forKey:@"user_id"];
//        [userInfo setObject:_nameText.text forKey:@"name"];
//        [userInfo setObject:_genderText.text forKey:@"gender"];
//         [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//             [self.navigationController popViewControllerAnimated:YES];
//
//         }];
//        
//           }else
//    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"昵称不能为空" preferredStyle:(UIAlertControllerStyleAlert)];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//  
//
    
   //    AVObject *userInfo = [AVObject objectWithClassName:@"UserInfo"];
//            [userInfo setObject:_nameText.text forKey:@"name"];
//            [userInfo setObject:_genderText.text forKey:@"gender"];
//    [userInfo saveInBackground];
    
    
    AVQuery * querry = [AVQuery queryWithClassName:@"UserInfo"];
    [querry whereKey:@"username" equalTo:[AVUser currentUser].username];
    [querry findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        
        
        
        AVObject *object = [objects firstObject];
        [object setObject:_nameText.text forKey:@"name"];
        [object setObject:_genderText.text forKey:@"gender"];
        NSLog(@"8888888%@",object);
        
        NSData * data = UIImagePNGRepresentation(_headImg.image);
        AVFile * file =[AVFile fileWithName:@"avatar.png" data:data];
        [object setObject:file forKey:@"avatar"];
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
              {
            if (succeeded) {
                NSLog(@"说出答案");
                
              }
        }];
        
        
    }];
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
            
            
            NSData *imageData = UIImagePNGRepresentation(_headImg.image);
            AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
            [imageFile save];
            
            AVObject *userPost = [AVObject objectWithClassName:@"Post"];
            [userPost setObject:@"My trip to Dubai!" forKey:@"content"];
            [userPost setObject:imageFile            forKey:@"attached"];
            [userPost save];

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
            
            
//            NSData *imageData = UIImagePNGRepresentation(_headImg.image);
//            AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
//            [imageFile save];
//            
//            AVObject *userPost = [AVObject objectWithClassName:@"Post"];
//            [userPost setObject:@"My trip to Dubai!" forKey:@"content"];
//            [userPost setObject:imageFile            forKey:@"attached"];
//            [userPost save];
   


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
    
    _headImg.image = info[UIImagePickerControllerEditedImage];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end