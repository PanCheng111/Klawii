//
//  AppDelegate.m
//  MagicPlay
//
//  Created by 潘成 on 16/4/9.
//  Copyright © 2016年 潘成. All rights reserved.
//

#import "AppDelegate.h"
#import "UMCommunity.h"

#import "UMCommunity.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
//#import "LoginViewController.h"
#import "UMComNavigationController.h"
#import "UMComSession.h"
#import "UMComNavigationController.h"


#import "ViewController.h"
#import "EAIntroView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UMCommunity setWithAppKey:@"5708a167e0f55a7bb5001a74"];
    UIViewController *mainVc = [UMCommunity getFeedsViewController];
    UMComNavigationController *rootVc = [[UMComNavigationController alloc]initWithRootViewController:mainVc];
    self.window.rootViewController = rootVc;
    
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([notificationDict valueForKey:@"umwsq"]) {//判断是否石友盟微社区的消息推送
        [UMComMessageManager startWithOptions:launchOptions];
        if ([notificationDict valueForKey:@"aps"]) // 点击推送进入
        {
            [UMComMessageManager didReceiveRemoteNotification:notificationDict];
        }
    } else {
        [UMComMessageManager startWithOptions:nil];
        //使用你的消息通知处理
    }

    
    [UMSocialWechatHandler setWXAppId:@"wx96110a1e3af63a39" appSecret:@"c60e3d3ff109a5d17013df272df99199" url:@"http://www.umeng.com/social"];
    //设置分享到QQ互联的appId和appKey
    [UMSocialQQHandler setQQWithAppId:@"1104606393" appKey:@"X4BAsJAVKtkDQ1zQ" url:@"http://www.umeng.com/social"];
    
    return YES;
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"----devicetoken------%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                       stringByReplacingOccurrencesOfString: @">" withString: @""]
                                      stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

@end
