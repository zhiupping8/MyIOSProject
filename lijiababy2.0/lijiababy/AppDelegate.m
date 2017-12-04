//
//  AppDelegate.m
//  lijiababy
//
//  Created by YongZhi on 20/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "AppDelegate.h"

#import "LJJPUSHController.h"

// 引入JPush功能所需头文件
#import <JPUSHService.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

//#import <JSPatchPlatform/JSPatch.h>

#import <AlipaySDK/AlipaySDK.h>

#import "WXApi.h"
#import "WXApiManager.h"


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import "LJALiPayController.h"

#import "LJLaunchIntroductionView.h"

#import "ViewController.h"
#import "LJCustomLaunchScreenView.h"

#import "DeepLinkKit.h"



@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, strong) DPLDeepLinkRouter *router;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    LJLaunchIntroductionView *launchIntroductionView = [LJLaunchIntroductionView sharedWithImages:@[@"guidance1.jpeg", @"guidance2.jpeg"]];
    launchIntroductionView.currentColor = [UIColor clearColor];
    launchIntroductionView.nomalColor = [UIColor clearColor];
    
    [LJCustomLaunchScreenView showCustomLaunchScreenViewWithStoryboardName:nil];
    
    UIWebView * tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *useragent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    useragent = [NSString stringWithFormat:@"%@ ljapp/%@", useragent, app_Version];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:useragent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        // 可以添加自定义categories
//        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions
                           appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    [LJJPUSHController shareController];
    // apn 内容获取：如果launchOptions包含UIApplicationLaunchOptionsRemoteNotificationKey表示用户点击apn 通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击apn而被启动，可能为直接点击icon被启动或其他
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        //用户点击apn进入程序
//        [[LJJPUSHController shareController] touchNotification:remoteNotification];
        ViewController *tmpController = (ViewController *)[self topViewController];
        [tmpController touchNotificationForFirst:remoteNotification];
        
//        if ([[UIApplication sharedApplication] applicationIconBadgeNumber] > 0) {
//            [UIApplication sharedApplication].applicationIconBadgeNumber--;
//        };
    }
    
    //角标清零
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"1d945ab7916d8"
     
          activePlatforms:@[
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformSubTypeQZone),
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeCopy)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106151706"
                                      appKey:@"lyI7aSq1hhEG24Ya"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:@"wx4441d3e858eea533"
//                                       appSecret:@"0b02d1f5b35cd5e4e43340d6276f20a5"];
                 [appInfo SSDKSetupWeChatByAppId:@"wx82fffe95ca96310d" appSecret:@"41e20f52ca88a3f3fdd02d5b47c4fc44"];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"3194181981"
                                           appSecret:@"f5310c67187ee927c0763559f0076a8b"
                                         redirectUri:@"http://ext.lijiababy.com.cn/oauth/weibo/callback"
                                            authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    //deeplink
    self.router = [[DPLDeepLinkRouter alloc] init];
    //浏览器调用url: "com.test.test://L/aa/123/456", 这样bb取到123, cc取到456
    __weak typeof(self) weakSelf = self;
    self.router[@"/log/:message"] = ^(DPLDeepLink *link) {
        ViewController *tmpController = (ViewController *)[weakSelf topViewController];
        NSString *urlString = [link.routeParameters[@"message"] stringByReplacingOccurrencesOfString:@"*" withString:@"/"];
        tmpController.url = urlString;
        [tmpController loadRequestWithURLString:urlString];
    };
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
    
    //每次唤醒都能同步更新 JSPatch 补丁，不需要等用户下次启动
//    [JSPatch sync];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
//程序在前台执行时,接受到通知消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [[LJJPUSHController shareController] receiveNewNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
//用户点击时通知消息时执行
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        [[LJJPUSHController shareController] touchNotification:userInfo];
        ViewController *tmpController = (ViewController *)[self topViewController];
        [tmpController touchNotificationForFirst:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [[LJJPUSHController shareController] receiveNewNotification:userInfo];
    } else {
//        [[LJJPUSHController shareController] touchNotification:userInfo];
        ViewController *tmpController = (ViewController *)[self topViewController];
        [tmpController touchNotificationForFirst:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [[LJJPUSHController shareController] receiveNewNotification:userInfo];
    } else {
//        [[LJJPUSHController shareController] touchNotification:userInfo];
        ViewController *tmpController = (ViewController *)[self topViewController];
        [tmpController touchNotificationForFirst:userInfo];
    }
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [self.router handleURL:url withCompletion:NULL];
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[LJALiPayController sharedInstance] dealWithResult:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [[LJALiPayController sharedInstance] dealWithResult:resultDic];
        }];
    } else {
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    [self.router handleURL:url withCompletion:NULL];
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[LJALiPayController sharedInstance] dealWithResult:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [[LJALiPayController sharedInstance] dealWithResult:resultDic];
        }];
    } else {
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    ViewController *tmpController = (ViewController *)[self topViewController];
    if ([shortcutItem.type isEqualToString:@"com.lijiaBabay.app.scan"]) {
        if ([tmpController respondsToSelector:@selector(scanOf3D)]) {
            [tmpController scanOf3D];
        }
    } else if ([shortcutItem.type isEqualToString:@"com.lijiaBabay.app.mylijia"]) {
        if ([tmpController respondsToSelector:@selector(gotoMyHome)]) {
            tmpController.url = @"http://m.lijiababy.com.cn/shopper-center";
            [tmpController gotoMyHome];
        }
    } else if ([shortcutItem.type isEqualToString:@"com.lijiaBabay.app.cart"]) {
        if ([tmpController respondsToSelector:@selector(gotoMyCart)]) {
            tmpController.url = @"http://m.lijiababy.com.cn/shopping-cart";
            [tmpController gotoMyCart];
        }
    } else if ([shortcutItem.type isEqualToString:@"com.lijiaBabay.app.nearby"]) {
        if ([tmpController respondsToSelector:@selector(gotoNearby)]) {
            tmpController.url = @"http://m.lijiababy.com.cn/stores";
            [tmpController gotoNearby];
        }
    }
}

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray *))restorationHandler {
    
    return [self.router handleUserActivity:userActivity withCompletion:NULL];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    resultVC = [self _topViewController:window.rootViewController];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
