//
//  ZiZhiAdDetailViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/16/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiAdDetailViewController.h"

@interface ZiZhiAdDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;

@end

@implementation ZiZhiAdDetailViewController

- (void)viewDidLoad {
    //    self.navigationItem.title = self.navigationItemtitle;
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cctv_log"]];
//    imageView.frame = CGRectMake(0, 0, 120, 37);
//    self.navigationItem.titleView = imageView;
    
    CGRect rect = self.navigationBarView.bounds;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, rect.size.height-3, screenRect.size.width, 3)];
    barImageView.image = [UIImage imageNamed:@"bar"];
    [self.navigationBarView addSubview:barImageView];
    
    
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [[NSURL alloc]initWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];//默认缓存策略
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = @"网络连接失败";
    [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
}

- (IBAction)touchBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kAdDetailMiss object:nil];
    }];
}
@end
