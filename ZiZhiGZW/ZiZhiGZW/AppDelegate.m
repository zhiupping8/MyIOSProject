//
//  AppDelegate.m
//  ZiZhiGZW
//
//  Created by zyz on 11/29/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "AppDelegate.h"
#import "BPush.h"
#import "WXApiManager.h"
#import "ZiZhiRootViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //开始的时候允许推送
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"kPushSetting"] == nil){
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:kPushSetting];
    }
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:8/255.0 green:171/255.0 blue:255/255.0 alpha:1.0]];
    
    // Override point for customization after application launch.
    UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [UINavigationBar appearance].backIndicatorImage = image;
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = image;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes: @{
                                                            NSFontAttributeName : [UIFont systemFontOfSize:20.0f]} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
#warning 测试 开发环境 时需要修改BPushMode为BPushModeDevelopment 需要修改Apikey为自己的Apikey
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey g9Y68zCuHTAnrjOgq6GkqP5a rncGN9D8BqiN2ob1YsqBssxc
    [BPush registerChannel:launchOptions apiKey:@"rncGN9D8BqiN2ob1YsqBssxc" pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    /*
     // 测试本地通知
     [self performSelector:@selector(testLocalNotifi) withObject:nil afterDelay:1.0];
     */
    
    [NSThread sleepForTimeInterval:1.0];
    return YES;
}

//- (void)testLocalNotifi
//{
//    NSLog(@"测试本地通知啦！！！");
//    NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:5];
//    [BPush localNotification:fireDate alertBody:@"这是本地通知" badge:3 withFirstAction:@"打开" withSecondAction:@"关闭" userInfo:nil soundName:nil region:nil regionTriggersOnce:YES category:nil];
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    CCLog(@"到这里%@",userInfo);
    
    ZiZhiRootViewController *rootVc = (ZiZhiRootViewController*)[self getCurrentVC];
    
    NSString *title = userInfo[@"title"];
    if ([Utils isBlankString:title]) {
        title = @"通知";
    }
    UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:title message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *checkAction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSInteger type = [userInfo[@"type"] integerValue];
        NSDictionary *dic;
        [rootVc notificationHandle:type content:dic];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:checkAction];
    [alertController addAction:cancelAction];
    [rootVc presentViewController:alertController animated:YES completion:^{
        
    }];
    completionHandler(UIBackgroundFetchResultNewData);
    
//    ZiZhiRootViewController *rootVc = (ZiZhiRootViewController*)[self getCurrentVC];
//    
//    
//    UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:@"通知" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *checkAction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        NSInteger type = [userInfo[@"type"] integerValue];
//        NSDictionary *dic;
//        [rootVc notificationHandle:type content:dic];
//        
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//    }];
//    [alertController addAction:checkAction];
//    [alertController addAction:cancelAction];
//    [rootVc presentViewController:alertController animated:YES completion:^{
//        
//    }];
//    completionHandler(UIBackgroundFetchResultNewData);
    
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        CCLog(@"123");
        [[NSNotificationCenter defaultCenter] postNotificationName:kALiPaySuccess2 object:resultDic];
    }];
    
    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    CCLog(@"drive token:%@", deviceToken);
    [BPush registerDeviceToken:deviceToken];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"kPushSetting"]isEqualToString:@"1"]){
        [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
            if(error==nil){
                CCLog(@"keyituisong");
                [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper].bChannerId = result[@"channel_id"];
                [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper].bUserId = result[@"user_id"];
            }
        }];
    }else {
        [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
            if(error==nil){
                [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper].bChannerId = result[@"channel_id"];
                [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper].bUserId = result[@"user_id"];
            }
        }];
    }
    
    
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"这个远程%@",userInfo);
    
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
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

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
