//
//  LJNotificationWebViewController.m
//  lijiababy
//
//  Created by YongZhi on 10/06/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJNotificationWebViewController.h"

@interface LJNotificationWebViewController ()<UIWebViewDelegate>

@end

@implementation LJNotificationWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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

    self.navigationItem.rightBarButtonItems = @[shareButtonItem];
    
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
        
        
        if (![urlString containsString:@"m.lijiababy.com.cn"] && ![urlString containsString:@"file:"] && ![urlString containsString:@"about:blank"] && ![urlString containsString:@"www.baidu.com"]) {
            [self.navigationController setNavigationBarHidden:NO];
        } else {
            [self.navigationController setNavigationBarHidden:YES];
        }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
