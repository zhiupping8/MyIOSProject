//
//  ZiZhiRootViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiRootViewController.h"
#import "ZiZhiADViewController.h"
#import "ZiZhiWebViewController.h"

#import "ZiZhiHomeViewController.h"
#import "ZiZhiUserCenterViewController.h"
#import "ZiZhiADModel.h"

#import "EAIntroView.h"

#import "ZiZhiMySignUpViewController.h"
#import "ZiZhiMyTicketTableViewCell.h"
#import "ZiZhiMyVipViewController.h"
#import "ZiZhiProgramSignUpViewController.h"

@interface ZiZhiRootViewController ()<UITabBarControllerDelegate, EAIntroDelegate>
@property (assign, nonatomic) NSInteger lastIndex;
@property (strong, nonatomic) EAIntroView *introView;
@end

@implementation ZiZhiRootViewController

- (void)initUI {
    UIImage *image = [UIImage imageNamed:@"bottombg"];
    CGRect rect = self.tabBar.bounds;
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width,rect.size.height+14));
    [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height+14)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.tabBar.backgroundImage = reSizeImage;
//    self.tabBar.layer.borderWidth = 0;
//    self.tabBar.layer.borderColor = [[UIColor clearColor] CGColor];
//    [self.tabBar setClipsToBounds:YES];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    NSArray *items = self.tabBar.items;
    UITabBarItem *homeItem0 = items[0];
    homeItem0.image = [[UIImage imageNamed:@"64-6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem0.selectedImage = [[UIImage imageNamed:@"64-6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *homeItem1 = items[1];
    homeItem1.image = [[UIImage imageNamed:@"64-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem1.selectedImage = [[UIImage imageNamed:@"64-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *homeItem2 = items[2];
//    homeItem2.imageInsets = UIEdgeInsetsMake(-16, -5, 6, -5);
    homeItem2.image = [[UIImage imageNamed:@"64-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem2.selectedImage = [[UIImage imageNamed:@"64-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    homeItem2.image = [[UIImage imageNamed:@"64-1"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(-16, -5, 6, -5)];
//    homeItem2.selectedImage = [[UIImage imageNamed:@"64-1"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(-16, -5, 6, -5)];
    
    UITabBarItem *homeItem3 = items[3];
    homeItem3.image = [[UIImage imageNamed:@"64-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem3.selectedImage = [[UIImage imageNamed:@"64-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *homeItem4 = items[4];
    homeItem4.image = [[UIImage imageNamed:@"64-5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem4.selectedImage = [[UIImage imageNamed:@"64-5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
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
    
    
    
    if ([Utils isFirstLaunch]) {
        [self initEAIntroView];
    }else {
        [self requestAD];
    }
}

- (void)initEAIntroView {
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIImageView *imageView0 = [[UIImageView alloc] initWithFrame:rect];
    imageView0.backgroundColor = [UIColor colorWithRed:0/255.0 green:162/255.0 blue:255/255.0 alpha:1.0];
    imageView0.contentMode = UIViewContentModeScaleAspectFit;
    imageView0.image = [UIImage imageNamed:@"APP1"];
    EAIntroPage *page0 = [EAIntroPage pageWithCustomView:imageView0];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:rect];
    imageView1.backgroundColor = [UIColor colorWithRed:0/255.0 green:162/255.0 blue:255/255.0 alpha:1.0];
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    imageView1.image = [UIImage imageNamed:@"APP2"];
    EAIntroPage *page1 = [EAIntroPage pageWithCustomView:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:rect];
    imageView2.backgroundColor = [UIColor colorWithRed:0/255.0 green:162/255.0 blue:255/255.0 alpha:1.0];
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    imageView2.image = [UIImage imageNamed:@"APP3"];
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageView:)];
    imageView2.userInteractionEnabled = YES;
    [imageView2 addGestureRecognizer:gesture];
    EAIntroPage *page2 = [EAIntroPage pageWithCustomView:imageView2];
    self.introView = [[EAIntroView alloc]initWithFrame:self.view.bounds andPages:@[page0, page1, page2]];
    [self.introView.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    [self.introView setDelegate:self];
    [self.introView showInView:self.view animateDuration:0.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchImageView:(UIGestureRecognizer *)gesture {
    [self.introView hideWithFadeOutDuration:0.0];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    self.lastIndex = self.selectedIndex;
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (3 == tabBarController.selectedIndex) {
        self.selectedIndex = self.lastIndex;
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008010798"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}
#pragma mark - EAIntroDelegate
- (void)introDidFinish:(EAIntroView *)introView {
    [self requestAD];
}

#pragma mark - Network request
- (void)requestAD {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    if ([ZiZhiLocalHelper fileExistsWithFileName:kADModelArchive]) {
        ZiZhiADModel *model = (ZiZhiADModel *)[ZiZhiLocalHelper unarchiveObjectWithFileName:kADModelArchive];
        [dictionary setObject:model.time forKey:@"lasttime"];
    }
    [[ZiZhiNetworkManager sharedManager] post:k_url_startadv parameters:dictionary success:^(NSDictionary *dictionary) {
        ZiZhiNetworkResponseModel *response = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == response.httpCode) {
            ZiZhiADModel *adModel = [ZiZhiADModel objectWithKeyValues:[dictionary objectForKey:@"content"]];
            ZiZhiADViewController *adVC = (ZiZhiADViewController *)[Utils getVCFromSB:@"ZiZhiADViewController" storyBoardName:nil];
            adVC.adModel = adModel;
            [self.view addSubview:adVC.view];
            [self addChildViewController:adVC];
        }else {
            
        }
        
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)notificationHandle:(NSInteger)type content:(NSDictionary*)content {
    if (2 == type) {
        [self gotoMyTicket];
    }else if (3 == type) {
        [self gotoMySignUp];
    }else if (4 == type) {
        [self gotoMyVip];
    }else if (5 == type) {
        [self gotoProgram];
    }else if (6 == type) {
        [self gotoMyTicket];
    }else if (7 == type) {
        [self gotoMyVip];
    }else if (8 == type) {
        [self gotoMySignUp];
    }
}

- (void)gotoMyTicket {
    [self setSelectedIndex:2];
    NSArray *array1 = [self viewControllers];
    UINavigationController *navigation = [array1 objectAtIndex:2];
    NSArray *array2 = [navigation viewControllers];
    ZiZhiUserCenterViewController *userCenterVC = [array2 objectAtIndex:0];
    [userCenterVC.segmentedControl setSelectedSegmentIndex:0 animated:YES];
    [userCenterVC.myTicketViewController.tableView.header beginRefreshing];
}

- (void)gotoMySignUp {
    
    [self setSelectedIndex:2];
    NSArray *array1 = [self viewControllers];
    UINavigationController *navigation = [array1 objectAtIndex:2];
    NSArray *array2 = [navigation viewControllers];
    ZiZhiUserCenterViewController *userCenterVC = [array2 objectAtIndex:0];
    [userCenterVC.segmentedControl setSelectedSegmentIndex:2 animated:YES];
    [userCenterVC.mySignUpViewController.tableView.header beginRefreshing];
}

- (void)gotoMyVip {
    
    [self setSelectedIndex:2];
    NSArray *array1 = [self viewControllers];
    UINavigationController *navigation = [array1 objectAtIndex:2];
    NSArray *array2 = [navigation viewControllers];
    ZiZhiUserCenterViewController *userCenterVC = [array2 objectAtIndex:0];
    [userCenterVC.segmentedControl setSelectedSegmentIndex:1 animated:YES];
    [userCenterVC.myVipViewController.tableView.header beginRefreshing];
}

- (void)gotoProgram {
    [self setSelectedIndex:0];
    NSArray *array1 = [self viewControllers];
    UINavigationController *navigation = [array1 objectAtIndex:0];
    NSArray *array2 = [navigation viewControllers];
    ZiZhiHomeViewController *homeVC = [array2 objectAtIndex:0];
    [homeVC.segmentedControl setSelectedSegmentIndex:1 animated:YES];
    [homeVC.programSignUpViewController.tableView.header beginRefreshing];
}

@end
