//
//  LJALiPayWebViewController.m
//  lijiababy
//
//  Created by YongZhi on 27/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJALiPayWebViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface LJALiPayWebViewController ()

@end

@implementation LJALiPayWebViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.webView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    
    // 加载已经配置的url
    NSString* webUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"alipayweburl"];
    if (webUrl.length > 0) {
        [self loadWithUrlStr:webUrl];
    }
}


#pragma mark -
#pragma mark   ============== webview相关 回调及加载 ==============

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* orderInfo = [[AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:[request.URL absoluteString]];
    if (orderInfo.length > 0) {
        [self payWithUrlOrder:orderInfo];
        return NO;
    }
    return YES;
}

- (void)loadWithUrlStr:(NSString*)urlStr
{
    if (urlStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
            [self.webView loadRequest:webRequest];
        });
    }
}


#pragma mark -
#pragma mark   ============== URL pay 开始支付 ==============

- (void)payWithUrlOrder:(NSString*)urlOrder
{
    if (urlOrder.length > 0) {
        __weak LJALiPayWebViewController* wself = self;
        [[AlipaySDK defaultService]payUrlOrder:urlOrder fromScheme:@"alisdkdemo" callback:^(NSDictionary* result) {
            // 处理支付结果
            NSLog(@"%@", result);
            // isProcessUrlPay 代表 支付宝已经处理该URL
            if ([result[@"isProcessUrlPay"] boolValue]) {
                // returnUrl 代表 第三方App需要跳转的成功页URL
                NSString* urlStr = result[@"returnUrl"];
                [wself loadWithUrlStr:urlStr];
            }
        }];
    }
}
@end
