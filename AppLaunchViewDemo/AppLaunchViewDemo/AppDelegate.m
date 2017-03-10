//
//  AppDelegate.m
//  AppLaunchViewDemo
//
//  Created by YuehaoHJ on 17/3/9.
//  Copyright © 2017年 Janye. All rights reserved.
//

#import "AppDelegate.h"
#import "AppLaunchView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    /*播放Bundle资源
//     * launchVideoName 视频资源
//     */
//    AppLaunchView *launchView1 = [[AppLaunchView alloc] initWithWindow:self.window
//                                                       launchVideoName:@"intro_video.mp4"];
//    //网络视频资源
//    launchView1.launchUrl = @"https://www.apple.com/media/us/airpods/2016/94916564_4bfa_4362_8b6c_b5c8fc822e3d/films/feature/airpods-feature-tft-cc-us-20160907_960x400.mp4";
//    
//    [launchView1 show];
    
    
    
    /*播放Bundle资源
     * launchType 展示类型
     */
    AppLaunchView *launchView2 = [[AppLaunchView alloc] initWithWindow:self.window
                                                            launchType:AppLaunchAnimCool];
    launchView2.launchImageName = @"139-1606030Z537.jpeg";
    launchView2.launchTime = 5;   //不填 默认为4
    [launchView2 show];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
