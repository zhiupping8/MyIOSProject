//
//  LJJPUSHController.m
//  lijiababy
//
//  Created by YongZhi on 20/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJJPUSHController.h"
#import "JPUSHService.h"
#import "AppDelegate.h"

@interface LJJPUSHController ()

@property (strong, nonatomic) JSValue *receiveNewNotificationJSCallback;
@property (strong, nonatomic) JSValue *touchNotificationJSCallback;

@property (strong, nonatomic) NSString *jpushRegistrationID;

@end


@implementation LJJPUSHController

+(instancetype)shareController {
    static dispatch_once_t onceToken;
    static LJJPUSHController *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LJJPUSHController alloc] init];
        [instance addNotificatioinObserver];
    });
    return instance;
}

//获取appKey
- (NSString *)getAppKey {
    return [appKey lowercaseString];
}

- (void)dealloc {
    [self unObserveAllNotifications];
}

#pragma mark - Notification Observer

- (void)addNotificatioinObserver {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    if ([JPUSHService registrationID]) {
        [self setUpRegistrationIDForLijiaAppJS:[JPUSHService registrationID]];
    }
}

//自定义消息处理
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    [self receiveNewNotification:userInfo];
//    NSString *title = [userInfo valueForKey:@"title"];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extra = [userInfo valueForKey:@"extras"];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    
//    NSString *currentContent = [NSString
//                                stringWithFormat:
//                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
//                                [NSDateFormatter localizedStringFromDate:[NSDate date]
//                                                               dateStyle:NSDateFormatterNoStyle
//                                                               timeStyle:NSDateFormatterMediumStyle],
//                                title, content, [self logDic:extra]];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}

- (void)receiveNewNotification:(NSDictionary *)userInfo {
//    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveNewNotification object:userInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.receiveNewNotificationJSCallback) {
            if (userInfo) {
                [self.receiveNewNotificationJSCallback callWithArguments:@[userInfo]];
            } else {
                NSDictionary *tmpDict = [NSDictionary new];
                [self.receiveNewNotificationJSCallback callWithArguments:@[tmpDict]];
            }
        }
    });
}

- (void)touchNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTouchNotification object:userInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.touchNotificationJSCallback) {
            if (userInfo) {
                [self.touchNotificationJSCallback callWithArguments:@[userInfo]];
            } else {
                NSDictionary *tmpDict = [NSDictionary new];
                [self.touchNotificationJSCallback callWithArguments:@[tmpDict]];
            }
        }
    });
    
}

#pragma mark - JS Interface

- (void)setUpRegistrationIDForLijiaAppJS:(NSString *)registrationID {
    if (registrationID) {
        //        self.homeWebViewContext[@"ljapp.registrationID"] = registrationID;
        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)registNotificationMethod:(JSValue *)receiveNewCallback touchCallback:(JSValue *)touchCallback {
    self.receiveNewNotificationJSCallback = receiveNewCallback;
    self.touchNotificationJSCallback = touchCallback;
}

- (void)getRegistrationID:(JSValue *)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (param) {
            NSString *registrationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
            if (registrationID) {
                [param callWithArguments:@[registrationID]];
            } else {
                [param callWithArguments:@[@""]];
            }
        }
    });
}

@end
