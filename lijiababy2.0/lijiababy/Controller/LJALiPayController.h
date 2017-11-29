//
//  LJALiPayController.h
//  lijiababy
//
//  Created by YongZhi on 27/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol AliPayExport <JSExport>

JSExportAs(aliPay, - (void)doAlipayPay:(JSValue *)orderString callback:(JSValue *)callback);

@end

@interface LJALiPayController : NSObject<AliPayExport>

+ (instancetype)sharedInstance;

- (void)doAlipayPay:(JSValue *)orderString callback:(JSValue *)callback;

- (void)dealWithResult:(NSDictionary *)result;

@end
