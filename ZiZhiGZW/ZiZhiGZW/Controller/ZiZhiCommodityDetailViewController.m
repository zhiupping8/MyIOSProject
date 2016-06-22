//
//  ZiZhiCommodityDetailViewController.m
//  ZiZhiGZW
//
//  Created by 张Yongzhi on 6/22/16.
//  Copyright © 2016 zizhi. All rights reserved.
//

#import "ZiZhiCommodityDetailViewController.h"
#import "MarqueeLabel.h"

@interface ZiZhiCommodityDetailViewController ()
@property (weak, nonatomic) IBOutlet MarqueeLabel *announcementLabel;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *tiptitleLabel;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;


@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ZiZhiCommodityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
