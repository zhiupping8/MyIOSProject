//
//  ViewController.m
//  lijiababy
//
//  Created by YongZhi on 20/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "ViewController.h"

#import "LJShareController.h"
#import "LJNotificationWebViewController.h"
#import "LJBuyScanViewController.h"


@interface ViewController ()<UIWebViewDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //3D Touch Notification
    [self add3DShareLJNotification];
    [self add3DScanNotification];
    [self add3DTouchMyCartNotification];
    [self add3DTouchMyHomeNotification];
    [self add3DTouchMyReceivingNotification];
    
    [self addTouchNotification];
    
//    [self addGoToCartNotification];

//    [self loadRequestWithURLString:@"http://m.lijiababy.com.cn/"];
//    [self loadRequestWithURLString:@"http://ls.youth2009.org/"];
//    [self loadRequestWithURLString:@"httpbin.org/status/502"];
//    [self loadRequestWithURLString:@"http://gc.youth2009.org/"];
//    [self loadRequestWithURLString:@"weixin://qr/dkyiuvPEg678rbfZ9xlk"];
//    [self loadRequestWithURLString:@"https://www.baidu.com"];
//    [self loadLocalHTMLWithFileName:@"functionTest"];
    
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self remove3DScanNotification];
    [self remove3DShareLJNotification];
    [self remove3DTouchMyCartNotification];
    [self remove3DTouchMyHomeNotification];
    [self remove3DTouchMyReceivingNotification];
    
    [self removeTouchNotificaiton];
//    [self removeGoToCartNotificaiton];
}

#pragma mark - 3D Touch Notification
- (void)add3DShareLJNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareLJOf3D) name:k3DTouchShare object:nil];
}

- (void)remove3DShareLJNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k3DTouchShare object:nil];
}

- (void)add3DScanNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanOf3D) name:k3DTouchScan object:nil];
}

- (void)remove3DScanNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k3DTouchScan object:nil];
}

- (void)add3DTouchMyHomeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMyHome) name:k3DTouchMyHome object:nil];
}

- (void)remove3DTouchMyHomeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k3DTouchMyHome object:nil];
}

- (void)add3DTouchMyCartNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMyCart) name:k3DTouchMyCart object:nil];
}

- (void)remove3DTouchMyCartNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k3DTouchMyCart object:nil];
}

- (void)add3DTouchMyReceivingNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMyReceiving) name:k3DTouchReceiving object:nil];
}

- (void)remove3DTouchMyReceivingNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k3DTouchReceiving object:nil];
}

#pragma mark - 3D Touch Notification Deal
- (void)shareLJOf3D {
    LJShareController *shareController = [LJShareController new];
    [shareController shareLJWithView:self.webView];
}

- (void)scanOf3D {
    [self scanWithCallBack:self.scanCallback];
}

- (void)gotoMyHome {
    [self loadRequestWithURLString:@"http://m.lijiababy.com.cn/shopper-center"];
}

- (void)gotoMyCart {
    [self loadRequestWithURLString:@"http://m.lijiababy.com.cn/shopping-cart"];
}

- (void)gotoNearby {
    [self loadRequestWithURLString:@"http://m.lijiababy.com.cn/stores"];
}

//- (void)gotoMyReceiving {
//    [self loadRequestWithURLString:@"http://m.lijiababy.com.cn/purchases"];
//}

#pragma mark - Push Notification
- (void)addTouchNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchNotification:) name:kTouchNotification object:nil];
}

- (void)removeTouchNotificaiton {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTouchNotification object:nil];
}

- (void)addGoToCartNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMyCart) name:kGoToCartNotification object:nil];
}

- (void)removeGoToCartNotificaiton {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGoToCartNotification object:nil];
}

- (void)touchNotification:(NSNotification *)notification {
    NSDictionary *userInfo = (NSDictionary *)[notification object];
    NSLog(@"Touch Notification UserInfo:%@", userInfo);
    NSDictionary *iOSInfo = [userInfo objectForKey:@"ios"];
    NSDictionary *extrasInfo = [iOSInfo objectForKey:@"extras"];
    if ([extrasInfo objectForKey:@"url"]) {
        LJNotificationWebViewController *webView = [[LJNotificationWebViewController alloc] initWithURL:[extrasInfo objectForKey:@"url"]];
        [self.navigationController pushViewController:webView animated:YES];
    }
}


@end
