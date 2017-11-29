//
//  LJWebViewController.m
//  lijiababy
//
//  Created by YongZhi on 04/06/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJWebViewController.h"

#import "LJQQScanViewController.h"
#import "StyleDIY.h"

#import "WXApiManager.h"

#import "LJLocationController.h"

#import "WXApiManager.h"
#import "LJALiPayController.h"
#import "LJShareController.h"

#import "LJBuyScanViewController.h"

#import <FFDropDownMenuView.h>

@implementation UIWebView (JavaScriptAlert)
static BOOL diagStat = NO;
-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    UIAlertView * customAlert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [customAlert show];
}

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"确定") otherButtonTitles:NSLocalizedString(@"取消", @"取消"), nil];
    
    [confirmDiag show];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    return diagStat;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        diagStat = YES;
        
    } else if (buttonIndex == 1) {
        diagStat = NO;
    }
}

@end

#define kScanNotification @"kScanNotification"

@interface LJWebViewController ()<UIWebViewDelegate, FFDropDownMenuViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDataDelegate, UIGestureRecognizerDelegate>

/** 下拉菜单 */
@property (nonatomic, strong) FFDropDownMenuView *dropdownMenu;

@property (weak, nonatomic) UIButton *button;

@property (copy, nonatomic) NSString *imageJS;

@end

@implementation LJWebViewController

-(instancetype)initWithURL:(NSString *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initWebView];
    if (self.url) {
        [self loadRequestWithURLString:self.url];
    } else {
        [self loadRequestWithURLString:@"http://m.lijiababy.com.cn/"];
//        [self loadLocalHTMLWithFileName:@"functionTest"];
    }
    
    [self addCreateJSContextObserver];
    
    [self addScanNotification];
    
    [self addRedirectNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    if (!self.navigationController.navigationBar.hidden) {
        self.webView.scrollView.contentInset=UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height, 0, 0, 0);
    } else {
        self.webView.scrollView.contentInset=UIEdgeInsetsZero;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeCreateJSContextObserver];
    [self removeScanNotification];
    [self removeRedirectNotification];
}

- (void)initWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    self.webView = webView;
    [self.view addSubview:webView];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
//    [self.webView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];;
    self.webView.scrollView.bounces = NO;
    
//    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey: @"WebKitCacheModelPreferenceKey"];
//    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey: @"WebKitMediaPlaybackAllowsInline"];
//    id tmpWebView = [self.webView valueForKeyPath:@"_internal.browserView._webView"];
//    id preferences = [tmpWebView valueForKey:@"preferences"];
//    [preferences performSelector:@selector(_postCacheModelChangedNotification)];
    
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [self.webView addGestureRecognizer:longPressed];
}

- (void)initNavigationBar {
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.exclusiveTouch = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    //share
    UIButton *shareButton = [[UIButton alloc] init];
//    [shareButton setTitle:@"share" forState:UIControlStateNormal];
//    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(0, 0, 30, 30);
    [shareButton addTarget:self action:@selector(shareCurrentPage:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.exclusiveTouch = YES;
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
//    [moreButton setTitle:@"more" forState:UIControlStateNormal];
//    [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    moreButton.frame = CGRectMake(0, 0, 30, 30);
    [moreButton addTarget:self action:@selector(touchMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.exclusiveTouch = YES;
    UIBarButtonItem *moreButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    self.navigationItem.rightBarButtonItems = @[moreButtonItem, shareButtonItem];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
//    self.title = @"丽家宝贝";
}

- (void)backAction:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)shareCurrentPage:(id)sender {
    LJShareController *shareController = [LJShareController new];
    NSString *url = [[[self.webView request] URL] absoluteString];
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    UIImage *image = [UIImage imageNamed:@"icon.png"];
    NSDictionary *tmpParams = @{@"url":url, @"title":title, @"images":@[image]};
    [shareController share:tmpParams shareCallback:nil withView:self.webView];
}

- (void)touchMoreButton:(id)sender {
    /** 初始化下拉菜单 */
    [self setupDropDownMenu];
    [self showDropDownMenu];
}

- (void)loadRequestWithURLString:(NSString *)url {
    NSURL *requestURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10.0];
    self.webView.delegate = self;
    self.url = url;
    [self.webView loadRequest:request];
}

- (void)loadLocalHTMLWithFileName:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:fileName
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (self.progressHUD) {
        [self.progressHUD hideAnimated:YES];
    }
    NSString *urlString = [request.URL absoluteString];
    NSString *schemeString = [request.URL scheme];
    NSLog(@"urlString:%@", urlString);
    if (![schemeString isEqualToString:@"http"] && ![schemeString isEqualToString:@"https"] && ![urlString containsString:@"file:"] && ![urlString containsString:@"about:blank"]) {
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:urlString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        } else {
            UIAlertView * customAlert = [[UIAlertView alloc]initWithTitle:nil message:@"未安装对应程序。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [customAlert show];
        }
        return NO;
    } else {
        self.progressHUD = [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
        self.progressHUD.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        self.progressHUD.contentColor = [UIColor whiteColor];
        
        
        if (![urlString containsString:@"m.lijiababy.com.cn"] && ![urlString containsString:@"file:"] && ![urlString containsString:@"about:blank"]) {
            [self.navigationController setNavigationBarHidden:NO];
        } else {
            [self.navigationController setNavigationBarHidden:YES];
        }
//        NSURL *requestURL = [NSURL URLWithString:urlString];
//        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10.0];
//        [newRequest setHTTPMethod:@"HEAD"];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError *_Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            NSLog(@"statusCode:%ld", (long)httpResponse.statusCode);
            if ([schemeString isEqualToString:@"http"] || [schemeString isEqualToString:@"https"]) {
                if ((([httpResponse statusCode]/100) != 2)) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.progressHUD) {
                            [self.progressHUD hideAnimated:YES];
                        }
                        [self loadLocalHTMLWithFileName:@"failure"];
                    });
                }
            }
        }];
        [dataTask resume];
        return YES;
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.progressHUD hideAnimated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *useragent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"user-agent:%@", useragent);
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.progressHUD hideAnimated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] == NSURLErrorCancelled) {
        [self.progressHUD hideAnimated:YES];
        return;
    }
    [self.progressHUD hideAnimated:YES];
    NSLog(@"webView didFailLoad:%@", error.localizedDescription);
    [self loadLocalHTMLWithFileName:@"failure"];
}


#pragma mark - Create JSContext Observer
- (void)addCreateJSContextObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateJSContext:) name:LJDidCreateContextNotification object:nil];
}

- (void)removeCreateJSContextObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LJDidCreateContextNotification object:nil];
}

- (void)didCreateJSContext:(NSNotification *)notification {
    NSString *indentifier = [NSString stringWithFormat:@"indentifier%lud", (unsigned long)self.webView.hash];
    NSString *indentifierJS = [NSString stringWithFormat:@"var %@ = '%@'", indentifier, indentifier];
    [self.webView stringByEvaluatingJavaScriptFromString:indentifierJS];
    
    JSContext *context = notification.object;
    //判断这个context是否属于当前这个webView
    if (![context[indentifier].toString isEqualToString:indentifier]) return;
    self.homeWebViewContext = context;
    
    [self addJPushContext:context];
    [self addLocationContext:context];
    [self addMapContext:context];
    [self addShareContext:context];
    [self addScanContext:context];
    [self addWXPayContext:context];
    [self addALiPayContext:context];
    [self addLongTouchContext:context];
    [self addPlatformInfo];
    [self addFailureContext:context];
//    [self addRegistrationID];
    
}

#pragma mark - Excute JavaScritp Observer

- (void)addPlatformInfo {
    self.homeWebViewContext[@"ljapp.clientType"] = @"ios";
}

//- (void)addRegistrationID {
//    NSString *registrationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
//    self.homeWebViewContext[@"ljapp.registrationID"] = registrationID;
//}

- (void)excuteJS:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.homeWebViewContext) {
            NSString *script = (NSString *)notification.object;
            [self.homeWebViewContext evaluateScript:script];
        }
    });
}

- (void)excuteRegistrationIDJS:(NSNotification *)notification {
    NSString *registrationID = notification.object;
    if (registrationID) {
//        self.homeWebViewContext[@"ljapp.registrationID"] = registrationID;
        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - Add Scan Notification
- (void)addScanNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navToScan:) name:kScanNotification object:nil];
}

- (void)removeScanNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kScanNotification object:nil];
}

- (void)addRedirectNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recognizeRedirect:) name:kRecognizeRedirectNotification object:nil];
}

- (void)removeRedirectNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRecognizeRedirectNotification object:nil];
}

- (void)navToScan:(NSNotification *)notification {
    JSValue *callback = (JSValue *)notification.object;
    LJQQScanViewController *qqScanVC = [LJQQScanViewController new];
    qqScanVC.style = [StyleDIY qqStyle];
    //镜头拉远拉近功能
    qqScanVC.isVideoZoom = YES;
    qqScanVC.scanResultBlock = ^(NSDictionary *resultInfo) {
        NSLog(@"scan resultInfo:%@", resultInfo);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                if (resultInfo) {
                    [callback callWithArguments:@[resultInfo]];
                } else {
                    NSDictionary *tmpDiction = [NSDictionary new];
                    [callback callWithArguments:@[tmpDiction]];
                }
            }
        });
        
    };
    [self.navigationController pushViewController:qqScanVC animated:YES];
}

- (void)recognizeRedirect:(NSNotification *)notification {
    NSString *url = (NSString *)notification.object;
    if ([url hasPrefix:@"http"]) {
        [self loadRequestWithURLString:url];
    }
}

#pragma mark - Add HomeWebView Context

- (void)addJPushContext:(JSContext *)context {
    LJJPUSHController *jpushViewController = [LJJPUSHController shareController];
    context[@"ljjpush"] = jpushViewController;	//将对象注入这个context中
}

- (void)addLocationContext:(JSContext *)context {
    LJLocationController *locationController = [LJLocationController new];
    context[@"ljlocation"] = locationController;
}

- (void)addMapContext:(JSContext *)context {
    context[@"ljmap"] = self;
}

- (void)addShareContext:(JSContext *)context {
    context[@"ljshare"] = self;
}

- (void)addScanContext:(JSContext *)context {
    context[@"ljscan"] = self;
}

- (void)addWXPayContext:(JSContext *)context {
    WXApiManager *wxPayManager = [WXApiManager sharedManager];
    context[@"ljwxpay"] = wxPayManager;
}

- (void)addALiPayContext:(JSContext *)context {
    LJALiPayController *aLiPayController = [LJALiPayController sharedInstance];
    context[@"ljalipay"] = aLiPayController;
}

- (void)addLongTouchContext:(JSContext *)context {
    context[@"ljTouch"] = self;
}

- (void)addFailureContext:(JSContext *)context {
    context[@"ljfailure"] = self;
}

#pragma mark - JS Interface

- (void)regitsterScanCallback:(JSValue *)callback {
    self.scanCallback = callback;
}

- (void)scanWithCallBack:(JSValue *)callback {
//    [[NSNotificationCenter defaultCenter] postNotificationName:kScanNotification object:callback];
    __weak typeof(self) weakSelf = self;
    LJQQScanViewController *qqScanVC = [LJQQScanViewController new];
    qqScanVC.style = [StyleDIY qqStyle];
    //镜头拉远拉近功能
    qqScanVC.isVideoZoom = YES;
    qqScanVC.scanResultBlock = ^(NSDictionary *resultInfo) {
        NSLog(@"scan resultInfo:%@", resultInfo);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                if (resultInfo) {
                    [callback callWithArguments:@[resultInfo]];
                } else {
                    NSDictionary *tmpDict = [NSDictionary new];
                    [callback callWithArguments:@[tmpDict]];
                }
            }
        });
    };
    [self.navigationController setNavigationBarHidden:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qqScanVC];
        //        [weakSelf.navigationController pushViewController:qqScanVC animated:YES];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    });
}

- (void)openMap:(JSValue *)locationInfo callback:(JSValue *)callback{
    LJMapController *mapController = [[LJMapController alloc] initWithCallback:callback];
    self.mapController = mapController;
    [mapController showActionSheetWithView:self.view location:locationInfo];
}

- (void)longTimeTouch:(JSValue *)params shareCallback:(JSValue *)shareCallback recognizeCallback:(JSValue *)recognizeCallback {
    LJLongTimeTouchController *longTimeTouch = [[LJLongTimeTouchController alloc] initWithView:self.webView];
    self.longTimeTouchController = longTimeTouch;
    [longTimeTouch longTimeTouch:params shareCallback:shareCallback recognizeCallback:recognizeCallback];
}

- (void)share:(JSValue *)params callback:(JSValue *)callback {
    LJShareController *shareController = [LJShareController new];
    [shareController share:params callback:callback withView:self.webView];
}

- (void)retry:(JSValue *)param {
    [self loadRequestWithURLString:self.url];
}

/** 初始化下拉菜单 */
- (void)setupDropDownMenu {
    NSArray *modelsArray = [self getMenuModelsArray];
    
    self.dropdownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray menuWidth:FFDefaultFloat eachItemHeight:FFDefaultFloat menuRightMargin:FFDefaultFloat triangleRightMargin:FFDefaultFloat];
    
    //如果有需要，可以设置代理（非必须）
    self.dropdownMenu.delegate = self;
    
    self.dropdownMenu.ifShouldScroll = NO;
    
    self.dropdownMenu.bgColorbeginAlpha = 0;
    self.dropdownMenu.bgColorEndAlpha = 0;
    self.dropdownMenu.menuWidth = 120;
    self.dropdownMenu.titleColor = [UIColor whiteColor];
    self.dropdownMenu.menuItemBackgroundColor = FFColor(0, 0, 0, 0.7);
    self.dropdownMenu.triangleColor = FFColor(0, 0, 0, 0.7);
    
    
    
    [self.dropdownMenu setup];
}



/** 获取菜单模型数组 */
- (NSArray *)getMenuModelsArray {
    __weak typeof(self) weakSelf = self;
    
    //菜单模型0
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"首页" menuItemIconName:@"home"  menuBlock:^{
        [weakSelf loadRequestWithURLString:@"http://m.lijiababy.com.cn/"];
    }];
    
    
    //菜单模型1
    FFDropDownMenuModel *menuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"购物车" menuItemIconName:@"cart" menuBlock:^{
        [weakSelf loadRequestWithURLString:@"http://m.lijiababy.com.cn/shopping-cart"];
    }];
    
    NSArray *menuModelArr = @[menuModel0, menuModel1];
    return menuModelArr;
}

/** 显示下拉菜单 */
- (void)showDropDownMenu {
    [self.dropdownMenu showMenu];
}


//=================================================================
//                      FFDropDownMenuViewDelegate
//=================================================================
#pragma mark - FFDropDownMenuViewDelegate

/** 可以在这个代理方法中稍微小修改cell的样式，比如是否需要下划线之类的 */
/** you can modify menu cell style, Such as if should show underline */
- (void)ffDropDownMenuView:(FFDropDownMenuView *)menuView WillAppearMenuCell:(FFDropDownMenuBasedCell *)menuCell index:(NSInteger)index {
    
    //若果自定义cell的样式，则在这里将  menuCell 转换成你自定义的cell
    FFDropDownMenuCell *cell = (FFDropDownMenuCell *)menuCell;
    
    //如果自定义cell,你可以在这里进行一些小修改，比如是否需要下划线之类的
    //最后一个菜单选项去掉下划线（FFDropDownMenuCell 内部已经做好处理，最后一个是没有下划线的，以下代码只是举个例子）
    cell.separaterView.backgroundColor = FFColor(255, 255, 255, 0.3);
    cell.iconSize = CGSizeMake(20, 20);
    if (menuView.menuModelsArray.count - 1 == index) {
        cell.separaterView.hidden = YES;
    }
    
    else {
        cell.separaterView.hidden = NO;
    }
    
}


#pragma mark - Long Press
- (void)longPressed:(UITapGestureRecognizer*)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self.webView];
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *imageUrl = [self.webView stringByEvaluatingJavaScriptFromString:js];
    if (imageUrl.length == 0) {
        return;
    }
    NSLog(@"image url：%@",imageUrl);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.longTouchShareParams toDictionary]];
    [dict setObject:imageUrl forKey:@"images"];
    JSValue *paramsValue = [JSValue valueWithObject:dict inContext:self.homeWebViewContext];
    [self longTimeTouch:paramsValue shareCallback:nil recognizeCallback:self.longTouchShareCallback];
    
//    __block UIImage *image = nil;
//    //图片下载链接
//    NSURL *imageDownloadURL = [NSURL URLWithString:imageUrl];
//    
//    //将图片下载在异步线程进行
//    //创建异步线程执行队列
//    dispatch_queue_t asynchronousQueue = dispatch_queue_create("imageDownloadQueue1", NULL);
//    //创建异步线程
//    dispatch_async(asynchronousQueue, ^{
//        //网络下载图片  NSData格式
//        NSError *error;
//        NSData *imageData = nil;
//        if (imageDownloadURL) {
//            imageData = [NSData dataWithContentsOfURL:imageDownloadURL options:NSDataReadingMappedIfSafe error:&error];
//        }
//        if (imageData) {
//            image = [UIImage imageWithData:imageData];
//        }
//        //回到主线程更新UI
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //TODO
//            NSLog(@"识别成功");
//        });
//    });
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)scanGoods:(JSValue *)callback {
    __weak typeof(self) weakSelf = self;
    LJBuyScanViewController *qqScanVC = [LJBuyScanViewController new];
    qqScanVC.style = [StyleDIY buyStyle];
    //镜头拉远拉近功能
    qqScanVC.isVideoZoom = YES;
    qqScanVC.inputBlock = ^(NSArray *goodsArray) {
        NSLog(@"scan goodsArray:%@", goodsArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                if (goodsArray) {
                    [callback callWithArguments:@[goodsArray]];
                } else {
                    NSArray *tmpArray = [NSArray new];
                    [callback callWithArguments:@[tmpArray]];
                }
            }
        });
        
    };
    [self.navigationController setNavigationBarHidden:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qqScanVC];
        //        [weakSelf.navigationController pushViewController:qqScanVC animated:YES];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    });
}

- (void)setShareInfo:(JSValue *)params callback:(JSValue *)callback {
    self.longTouchShareParams = params;
    self.longTouchShareCallback = callback;
}


@end
