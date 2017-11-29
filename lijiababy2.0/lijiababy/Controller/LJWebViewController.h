//
//  LJWebViewController.h
//  lijiababy
//
//  Created by YongZhi on 04/06/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJJPUSHController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LJMapController.h"
#import "LJLongTimeTouchController.h"
#import "LJShareController.h"
#import "LJBuyScanViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface UIWebView (JavaScriptAlert)
-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
@end

@protocol ScanExport <JSExport>

JSExportAs(scan, - (void)scanWithCallBack:(JSValue *)callback);

JSExportAs(register, - (void)regitsterScanCallback:(JSValue *)callback);

@end

@protocol OpenMapExport <JSExport>

JSExportAs(openMap, - (void)openMap:(JSValue *)locationInfo callback:(JSValue *)callback);

@end

@protocol LongTimeTouchExport <JSExport>

JSExportAs(longTimeTouch, - (void)longTimeTouch:(JSValue *)params shareCallback:(JSValue *)shareCallback recognizeCallback:(JSValue *)recognizeCallback);

@end

@protocol ShareExport <JSExport>

JSExportAs(share, - (void)share:(JSValue *)params callback:(JSValue *)callback);

@end

@protocol FailureExport <JSExport>

JSExportAs(retry, - (void)retry:(JSValue *)param);

@end

@protocol ScanGoodsExport <JSExport>

JSExportAs(scanGoods, - (void)scanGoods:(JSValue *)callback);

JSExportAs(setShareInfo, - (void)setShareInfo:(JSValue *)params callback:(JSValue *)callback);

@end

@interface LJWebViewController : UIViewController<ScanExport, OpenMapExport, LongTimeTouchExport, ShareExport, FailureExport, ScanGoodsExport>

@property (strong, nonatomic) NSString *url;

@property (weak, nonatomic)UIWebView *webView;

@property (strong, nonatomic) LJMapController *mapController;
@property (strong, nonatomic) LJLongTimeTouchController *longTimeTouchController;

@property (strong, nonatomic) JSContext *homeWebViewContext;

@property (strong, nonatomic) JSValue *scanCallback;

@property (nonatomic, strong) JSValue *longTouchShareParams;
@property (nonatomic, strong) JSValue *longTouchShareCallback;

@property (weak, nonatomic) MBProgressHUD *progressHUD;

- (instancetype)initWithURL:(NSString *)url;

- (void)loadRequestWithURLString:(NSString *)url;
- (void)loadLocalHTMLWithFileName:(NSString *)fileName;
- (void)scanWithCallBack:(JSValue *)callback;


@end
