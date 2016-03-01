//
//  HTWriteTravelRecordTableViewController.m
//  WriteRecord
//
//  Created by 杨晓伟 on 16/1/19.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTWriteTravelRecordTableViewController.h"
#import "HTNavigationBar.h"
#import "HTWriteTravelRecordDatePickerViewController.h"
#import "IQActionSheetPickerView.h"
#import "IQActionSheetViewController.h"
#import "UzysAssetsPickerController.h"
#import <Photos/Photos.h>
#import "HTRecordContentEditViewController.h"
#import "HTDistrictSearchViewController.h"
#import "HTDistrictSearchModel.h"
#import "AVOSCloud.h"
#import "HTTravelRecordModel.h"
#import "HTRecordContentModel.h"
#import "HTDistrictModel.h"
#import <RESideMenu/RESideMenu.h>
#import "HTTravelRecordTableViewController.h"
#import "GetUser.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kGap 5
#define kImgWidth (kScreenWidth - 4 * kGap) / 3
#define kFontSize 14

@interface HTWriteTravelRecordTableViewController () <IQActionSheetPickerViewDelegate,UzysAssetsPickerControllerDelegate, UITextViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) NSString *travelRecordText;

@property (strong, nonatomic) NSString *topicTitle;

@property (strong, nonatomic) NSMutableArray *images;

@property (strong, nonatomic) NSMutableArray *titleArray;

@property (strong, nonatomic) HTTravelRecordModel *travelRecordModel;

@property (strong, nonatomic) HTDistrictSearchModel *districtSearchModel;

@end

static NSString *const HTWriteRecordCellID = @"HTWriteRecordCellIdentifier";

@implementation HTWriteTravelRecordTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    
    if (self) {
        
        _travelRecordText = nil;
        _topicTitle = nil;
        _titleArray = @[@"旅行日期",@"目的地"].mutableCopy;
//        _travelRecordModel = [[HTTravelRecordModel alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HTWriteRecordCellID];
    HTNavigationBar *htBar = [HTNavigationBar new];
    htBar.alpha = 0.00001;
    htBar.titleLabel.text = @"写游记";
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(5, 20, 40, htBar.frame.size.height - 20);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [htBar.barColorView addSubview:cancelButton];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(htBar.frame.size.width - 45, 20, 40, htBar.frame.size.height - 20);
    [commitButton setTitle:@"发布" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [commitButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [htBar.barColorView addSubview:commitButton];
    
    [self.navigationController setValue:htBar forKey:@"navigationBar"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 3;
    }
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 20;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return 40;
        } else if(indexPath.row == 1) {
            
            CGFloat height = [self caculateHeightForFieldWithString:self.travelRecordText];
            
            if (height < 100) {
                
                height = 100;
            } else {
                
                height += 10;
            }
            return height;
        } else {
            
            if (self.images == nil) {
                
                return kImgWidth + 2 * kGap;
            } else {
                
                NSInteger num = 1 + self.images.count / 3;
                
                if (num >= 3) {
                    
                    num = 3;
                }
                
                return (kImgWidth + kGap) * num + kGap;
            }
        }
    }
    
    return 40;
}

/**
 *  计算文本的高度
 *
 *  @param string 需要计算的文本
 *
 *  @return 文本高度
 */
- (CGFloat)caculateHeightForFieldWithString:(NSString *)string {
    
    if ([string isEqualToString:@""]) {
        
        return 0;
    }
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize topicSize = [string boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 10000) options:option attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;

    return topicSize.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HTWriteRecordCellID forIndexPath:indexPath];
    
    // 设置第一组cell情况
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            // 设置标题行尺寸
            CGRect frame = cell.contentView.bounds;
            frame.origin.x = 5;
            frame.size.width = frame.size.width - 10;
            
            UITextField *field = [[UITextField alloc] initWithFrame:frame];
            
            if (self.topicTitle.length == 0) {
                
                field.placeholder = @"标题";
            } else {
                
                field.text = self.topicTitle;
            }
            field.backgroundColor = [UIColor whiteColor];
            // 当编辑时出现清除button
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.font = [UIFont systemFontOfSize:kFontSize];
            field.delegate = self;
            [cell.contentView addSubview:field];
        } else if (indexPath.row == 1) {
            
            CGRect frame = cell.contentView.bounds;
            frame.origin.x = 5;
            frame.size.width = frame.size.width - 10;
            
            UITextView *field = [[UITextView alloc] initWithFrame:frame];
            
            field.bounces = NO;
            if (self.travelRecordText.length == 0) {
                field.text = @"经历与感想...";
                field.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6];
            } else {
                
                field.text = self.travelRecordText;
            }
            
            field.font = [UIFont systemFontOfSize:kFontSize];
            
            field.delegate = self;
            
            [cell.contentView addSubview:field];
        } else {
            
            UIView *view = [[UIView alloc] initWithFrame:cell.contentView.bounds];
            
            if (self.images == nil) {
                
                UIImage *cameraImg = [UIImage imageNamed:@"writeTravelRecord_Camera"];
                cameraImg = [cameraImg stretchableImageWithLeftCapWidth:cameraImg.size.width topCapHeight:cameraImg.size.height];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, kImgWidth, kImgWidth)];
                
                imageView.contentMode = UIViewContentModeCenter;
                imageView.image = cameraImg;
                imageView.layer.borderColor = [UIColor grayColor].CGColor;
                imageView.layer.borderWidth = 1;
                [view addSubview:imageView];
            } else if (self.images.count < 9) {
                
                for (int i = 0; i < self.images.count; i++) {
                    
                    NSInteger x = i % 3;
                    NSInteger y = i / 3;
                    
                    UIImage *img = self.images[i];
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x * (5 + kImgWidth) + 5, y * (5 + kImgWidth) + 5, kImgWidth, kImgWidth)];
                    imageView.image = img;
                    imageView.layer.borderColor = [UIColor grayColor].CGColor;
                    imageView.layer.borderWidth = 1;
                    [view addSubview:imageView];
                }
                
                NSInteger x = self.images.count % 3;
                NSInteger y = self.images.count / 3;
                UIImage *cameraImg = [UIImage imageNamed:@"writeTravelRecord_Camera"];
                cameraImg = [cameraImg stretchableImageWithLeftCapWidth:cameraImg.size.width topCapHeight:cameraImg.size.height];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x * (5 + kImgWidth) + 5, y * (5 + kImgWidth) + 5, kImgWidth, kImgWidth)];
                imageView.contentMode = UIViewContentModeCenter;
                imageView.image = cameraImg;
                imageView.layer.borderColor = [UIColor grayColor].CGColor;
                imageView.layer.borderWidth = 1;
                [view addSubview:imageView];
            } else if (self.images.count == 9) {
                
                for (int i = 0; i < self.images.count; i++) {
                    
                    NSInteger x = i % 3;
                    NSInteger y = i / 3;
                    
                    UIImage *img = self.images[i];
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x * (5 + kImgWidth) + 5, y * (5 + kImgWidth) + 5, kImgWidth, kImgWidth)];
                    imageView.image = img;
                    imageView.layer.borderColor = [UIColor grayColor].CGColor;
                    imageView.layer.borderWidth = 1;
                    [view addSubview:imageView];
                }
            }
            [cell.contentView addSubview:view];
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            cell.imageView.image = [UIImage imageNamed:@"writeTravelRecord_Date"];
            cell.imageView.frame = CGRectMake(0, 0, 40, 40);
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if ([self.titleArray[indexPath.row] isEqualToString:@"旅行日期"]) {
                
                cell.textLabel.textColor = [UIColor grayColor];
            } else {
                
                cell.textLabel.textColor = [UIColor blackColor];
            }
            cell.textLabel.text = self.titleArray[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:kFontSize];
            
            
        } else {
            
            cell.imageView.image = [UIImage imageNamed:@"writeTravelRecord_Map"];
            cell.imageView.frame = CGRectMake(0, 0, 40, 40);
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.textLabel.text = self.titleArray[indexPath.row];
            
            if ([self.titleArray[indexPath.row] isEqualToString:@"目的地"]) {
                
                cell.textLabel.textColor = [UIColor grayColor];
            } else {
                
                cell.textLabel.textColor = [UIColor blackColor];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:kFontSize];
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 2) {
            
            UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
            picker.delegate = self;
            picker.maximumNumberOfSelectionVideo = 0;
            picker.maximumNumberOfSelectionPhoto = 9;
            [self presentViewController:picker animated:YES completion:nil];
        }
        
    } else {
        
        if (indexPath.row == 0) {

            IQActionSheetPickerView *sheetPickerView = [[IQActionSheetPickerView alloc] initWithTitle:@"旅行日期" delegate:self];
            
            sheetPickerView.barColor = [UIColor whiteColor];
            sheetPickerView.backgroundColor = [UIColor whiteColor];
            [sheetPickerView setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
            
            [sheetPickerView show];
        }
        
        if (indexPath.row == 1) {
            
            HTDistrictSearchViewController *htDistrictSearchVC = [[HTDistrictSearchViewController alloc] initWithStyle:(UITableViewStylePlain)];
            
            __unsafe_unretained typeof(self) weakSelf = self;
            htDistrictSearchVC.districtPassBlock = ^(HTDistrictSearchModel *model) {
                
                weakSelf.titleArray[1] = model.name;
                weakSelf.districtSearchModel = model;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                });
                
            };
            
            UINavigationController *htDistrictSearchNC = [[UINavigationController alloc] initWithRootViewController:htDistrictSearchVC];
            
            [self presentViewController:htDistrictSearchNC animated:YES completion:nil];
        }
    }
    
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [((HTNavigationBar *)(self.navigationController.navigationBar)) changeColorWithOffset:scrollView.contentOffset.y color:[UIColor greenColor]];
}

#pragma mark --实现日期选择器代理协议--
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate*)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateString = [formatter stringFromDate:date];
    
    self.titleArray[0] = dateString;
    
    [self.tableView reloadData];
    
}

#pragma mark --实现图片选中器代理协议--
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    __weak typeof(self) weakSelf = self;
    
    self.images = [NSMutableArray array];
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            
            [weakSelf.images addObject:img];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
        
    }
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[NSString stringWithFormat:@"最多只能选择%ld张",picker.maximumNumberOfSelectionPhoto]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark --UITextView代理--

- (BOOL)textViewShouldBeginEditing:(UITextView *)textField {
    
    if ([textField.text isEqualToString:@"经历与感想..."]) {
        
        textField.text = @"";
    }
    
    textField.textColor = [UIColor blackColor];
    
    HTRecordContentEditViewController *htRecordContentEditVC = [[HTRecordContentEditViewController alloc] init];
    
    htRecordContentEditVC.contentTextView.text = textField.text;

    
    __unsafe_unretained typeof(self) weakSelf = self;
    htRecordContentEditVC.contentPassBlock = ^(NSString *content) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.travelRecordText = content;
            
            [self.tableView reloadData];
            
        });
    };

    UINavigationController *htRecordContentEditNC = [[UINavigationController alloc] initWithRootViewController:htRecordContentEditVC];
    
    [self presentViewController:htRecordContentEditNC animated:YES completion:nil];
    return NO;
}

#pragma mark --textField代理--
// 文本结束编辑时调用的方法
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    self.topicTitle = textField.text;
    [self.tableView reloadData];
}

// 点击return键后调用的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

//TODO: 发布取消按钮的实现
#pragma mark --Button响应事件--
- (void)cancelAction:(UIButton *)sender {
    
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)commitAction:(UIButton *)sender {
    
    AVObject *travelRecord = [AVObject objectWithClassName:@"TravelRecord"];
    
    [travelRecord setObject:self.topicTitle forKey:@"topic"];
    [travelRecord setObject:self.travelRecordText forKey:@"desc"];
    [travelRecord setObject:@(self.images.count) forKey:@"contents_count"];
    
    NSMutableArray *contents = [NSMutableArray array];
    
    for (int i = 0; i < self.images.count; i++) {
        UIImage *image = [self imageCompressForWidth:self.images[i] targetWidth:kScreenWidth];
        NSData *imageData = UIImagePNGRepresentation(image);
        AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];

        NSLog(@"%@",imageFile);
    
        if ([imageFile save]) {
            
            NSLog(@"%d个图片已存放",i+1);
            NSLog(@"%@",imageFile.url);
        }
        
        HTRecordContentModel *imageModel = [[HTRecordContentModel alloc] init];
        imageModel.height = image.size.height;
        imageModel.width = image.size.width;
        imageModel.photo_url = imageFile.url;
        imageModel.position = i;
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:imageModel];
        
        NSLog(@"%@",data);
        
        [contents addObject:data];
    }
    
    [travelRecord setObject:contents forKey:@"contents"];
    [travelRecord setObject:@(self.districtSearchModel.district_id) forKey:@"district_id"];
    
    HTDistrictModel *districtModel = [[HTDistrictModel alloc] init];
    districtModel.district_id = self.districtSearchModel.district_id;
    districtModel.name = self.districtSearchModel.name;
    
    NSData *districtData = [NSKeyedArchiver archivedDataWithRootObject:districtModel];
    NSMutableArray *districts = [NSMutableArray array];
    [districts addObject:districtData];
    
    [travelRecord setObject:districts forKey:@"districts"];

    GetUser *user = [GetUser shareGetUser];
    [travelRecord setObject:@(user.user_id) forKey:@"user_id"];
    [travelRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            [self showSuccessAlert];
        }
    }];
   
}

- (void)showSuccessAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        
        HTTravelRecordTableViewController *diaryVC = [[HTTravelRecordTableViewController alloc]init];
        UINavigationController *diaryNC = [[UINavigationController alloc] initWithRootViewController:diaryVC];
        
        //替换当前视图
        [self.sideMenuViewController setContentViewController:diaryNC];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

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


@end
