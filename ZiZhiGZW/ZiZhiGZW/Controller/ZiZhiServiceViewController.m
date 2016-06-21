//
//  ZiZhiServiceViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 11/29/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiServiceViewController.h"

@interface ZiZhiServiceViewController ()
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *serviceImageView;

@end

@implementation ZiZhiServiceViewController

- (void)goToQQ:(UITapGestureRecognizer *)gesture {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *urlString = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%d&version=1&src_type=web",gesture.view.tag];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

//add gesture to qq customer service
- (void)addGestureToServiceImageView {
    for (UIImageView *imageView in self.serviceImageView) {
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToQQ:)];
        [imageView addGestureRecognizer:gesture];
    }
}

- (void)initUI {
    [self addGestureToServiceImageView];
    
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
