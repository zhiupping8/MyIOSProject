//
//  ZiZhiWebViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiWebViewController.h"

@interface ZiZhiWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation ZiZhiWebViewController

- (void)viewDidLoad {
//    self.navigationItem.title = self.navigationItemtitle;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 36, 36)];
    imageView.image = [UIImage imageNamed:@"64-1"];
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 90, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.text = @"中视观众";
    [view addSubview:titleLabel];
    self.navigationItem.titleView = view;
    
    CGRect rect = self.navigationController.navigationBar.bounds;
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, rect.size.height-3, rect.size.width, 3)];
    barImageView.image = [UIImage imageNamed:@"bar"];
    [self.navigationController.navigationBar addSubview:barImageView];
    
    
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.scalesPageToFit = NO;
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @class requestWithUrlStr
 * @explain 获取页面
 */
-(void)request{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [[NSURL alloc]initWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];//默认缓存策略
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.hud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabelText = @"网络连接失败";
    [self.hud hide:YES afterDelay:kMBProgressHUDTipsTime];
}

@end
