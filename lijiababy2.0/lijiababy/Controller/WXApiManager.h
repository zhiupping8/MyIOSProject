//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol WXPayExport <JSExport>

JSExportAs(wxPay, - (void)jumpToBizPay:(JSValue *)dict callback:(JSValue *)callback);

@end

@interface WXApiManager : NSObject<WXPayExport, WXApiDelegate>

+ (instancetype)sharedManager;

- (void)jumpToBizPay:(JSValue *)dict callback:(JSValue *)callback;

@end
