//
//  LJJPUSHController.h
//  lijiababy
//
//  Created by YongZhi on 20/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

//#define kReceiveNewNotification @"kReceiveNewNotification"
#define kTouchNotification @"kTouchNotification"

@protocol JPushExport <JSExport>

JSExportAs(registMessageMethod, - (void)registNotificationMethod:(JSValue *)receiveNewCallback touchCallback:(JSValue *)touchCallback);
JSExportAs(getRegistrationID, - (void)getRegistrationID:(JSValue *)param);

@end

@interface LJJPUSHController : NSObject<JPushExport>

+ (instancetype)shareController;

- (void)receiveNewNotification:(NSDictionary *)userInfo;
- (void)touchNotification:(NSDictionary *)userInfo;

@end
