//
//  AppDelegate.m
//  HeartTravel
//
//  Created by 杨晓伟 on 16/1/15.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "AppDelegate.h"



#import "HTWorldExploreViewController.h"
#import "HTLeftMenuViewController.h"
#import <RESideMenu/UIViewController+RESideMenu.h>
#import <RESideMenu/RESideMenu.h>
#import <AVOSCloud.h>
#import "GetUser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setLeanCloudID];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    HTLeftMenuViewController *leftMenuViewController = [[HTLeftMenuViewController alloc] init];
    
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc]initWithContentViewController:[HTWorldExploreViewController new] leftMenuViewController:leftMenuViewController rightMenuViewController:nil];
    
    self.window.rootViewController = sideMenuViewController;
    
    [NSThread sleepForTimeInterval:1];


    return YES;
}

// 配置LeanCloud
- (void)setLeanCloudID {
    
    //如果使用美国站点，请加上这行代码 [AVOSCloud useAVCloudUS];
    [AVOSCloud setApplicationId:@"piMGRX2E0qMN0tEPtslCE2u6-gzGzoHsz"
                      clientKey:@"ziH0tPvQNV26XJBOWjm4fCuJ"];
    // 如果想跟踪统计应用的打开情况,后面还可以添加下列代码：[AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.


}


@end
