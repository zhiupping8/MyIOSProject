//
//  ZiZhiUserCenterViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/9/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiUserCenterViewController.h"


@interface ZiZhiUserCenterViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *segmentedScrollView;

@property (nonatomic, strong) NSArray *titles;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *identifyLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIView *anotherButtonsView;

@end

@implementation ZiZhiUserCenterViewController

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"我的赠票", @"我的VIP", @"我的报名"];
    }
    return _titles;
}

- (void)initSegmentedControl {
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.titles];
    CGFloat segmentedControlY = self.buttonsView.frame.origin.y +self.buttonsView.frame.size.height;
    [self.segmentedControl setFrame:CGRectMake(0, segmentedControlY, kScreenWidth, kSegmentedControlHeight)];
    self.segmentedControl.selectionIndicatorHeight = kSelectionIndicatorHeight;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName: kTitleTextForegroundColor};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: kSelectedTitleTextForegroundColor};
    self.segmentedControl.selectionIndicatorColor = kSelectionIndicatorColor;
    //    self.segmentedControl.backgroundColor = kSegmentedControlBackgroundColor;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.shouldAnimateUserSelection = YES;
    
    CGFloat segmentedScrollViewHeight = kScreenHeight - self.segmentedControl.frame.origin.y - self.segmentedControl.frame.size.height;
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.segmentedScrollView scrollRectToVisible:CGRectMake(kScreenWidth * index, 0, kScreenWidth,segmentedScrollViewHeight) animated:YES];
    }];
    [self.view addSubview:self.segmentedControl];
    
    self.segmentedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentedControlY + kSegmentedControlHeight, kScreenWidth, segmentedScrollViewHeight)];
    self.segmentedScrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.segmentedScrollView.pagingEnabled = YES;
    self.segmentedScrollView.showsHorizontalScrollIndicator = NO;
    self.segmentedScrollView.contentSize = CGSizeMake(kScreenWidth * self.titles.count, segmentedScrollViewHeight);
    self.segmentedScrollView.delegate = self;
    self.segmentedScrollView.bounces = NO;
    [self.segmentedScrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, segmentedScrollViewHeight) animated:NO];
    [self.view addSubview:self.segmentedScrollView];
    
    ZiZhiMyTicketViewController *myTicketVC = (ZiZhiMyTicketViewController *)[Utils getVCFromSB:@"ZiZhiMyTicketViewController" storyBoardName:nil];
    self.myTicketViewController = myTicketVC;
    myTicketVC.view.frame = CGRectMake(0, 0, self.segmentedScrollView.frame.size.width, self.segmentedScrollView.frame.size.height);
    [self.segmentedScrollView addSubview:myTicketVC.view];
    [self addChildViewController:myTicketVC];
    
    ZiZhiMyVipViewController *myVipVC = (ZiZhiMyVipViewController *)[Utils getVCFromSB:@"ZiZhiMyVipViewController" storyBoardName:nil];
    self.myVipViewController = myVipVC;
    myVipVC.view.frame = CGRectMake(self.segmentedScrollView.frame.size.width, 0, self.segmentedScrollView.frame.size.width, self.segmentedScrollView.frame.size.height);
    [self.segmentedScrollView addSubview:myVipVC.view];
    [self addChildViewController:myVipVC];
    
    ZiZhiMySignUpViewController *mySignUpVC = (ZiZhiMySignUpViewController *)[Utils getVCFromSB:@"ZiZhiMySignUpViewController" storyBoardName:nil];
    self.mySignUpViewController = mySignUpVC;
    mySignUpVC.view.frame = CGRectMake(self.segmentedScrollView.frame.size.width * 2, 0, self.segmentedScrollView.frame.size.width, self.segmentedScrollView.frame.size.height);
    [self.segmentedScrollView addSubview:mySignUpVC.view];
    [self addChildViewController:mySignUpVC];
}

- (void)initUI {
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
    
    self.anotherButtonsView.hidden = YES;
    [self initSegmentedControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyToLogin:) name:kLoginNotification object:nil];
    CCLog(@"user center viewdidload");
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginNotification object:nil];
}

#pragma mark - Notification method
- (void)applyToLogin:(NSNotification *)notification {
    CCLog(@"接到登录通知");
    NSDictionary *dictionary = [notification object];
    [self requestLogin:[dictionary objectForKey:@"idcardnumber"] phone:[dictionary objectForKey:@"phone"]];
}

- (void)updateUI {
    ZiZhiUserInfoLocalHelperModel *helper = [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper];
    if ([helper isLogin]) {
        self.logoutButton.hidden = NO;
        self.anotherButtonsView.hidden = NO;
        self.buttonsView.hidden = YES;
        //如何判断头像
        CCLog(@"评委:%@", helper.userInfoModel.isAudienceRater);
        if ([helper.userInfoModel.isAudienceRater isEqualToString:@"true"]) {
            self.headImageView.image = [UIImage imageNamed:@"64-13"];
        }else {
            self.headImageView.image = [UIImage imageNamed:@"64-14"];
        }
        NSString *idCardNumber1 = [helper.userInfoModel.idCardNumber stringByReplacingCharactersInRange:NSMakeRange(3, helper.userInfoModel.idCardNumber.length-6) withString:@"************"];
        self.identifyLabel.text = idCardNumber1;
        
        [self.myTicketViewController.tableView.header beginRefreshing];
        [self.myVipViewController.tableView.header beginRefreshing];
        [self.mySignUpViewController.tableView.header beginRefreshing];
    }else {
        self.anotherButtonsView.hidden = YES;
        self.buttonsView.hidden = NO;
        self.logoutButton.hidden = YES;
        self.headImageView.image = [UIImage imageNamed:@"64-15"];
        self.identifyLabel.text = @"亲! 你还未登录哦";
        [self.mySignUpViewController logout];
        [self.myTicketViewController logout];
        [self.myVipViewController logout];
    }
}

#pragma mark - Touch Event
- (IBAction)touchUserRegisterButton:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];

    UIAlertAction *postAction = [UIAlertAction actionWithTitle:@"注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *idCardNumber = alertController.textFields[0].text;
        NSString *phoneNumber = alertController.textFields[1].text;
        [self requestRegist:idCardNumber phone:phoneNumber];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"身份证号";
        UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"64-8"]];
        [imgv setFrame:CGRectMake(0, 0, 20, 20)];
         
        textField.leftView = imgv;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"手机号";
        UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"64-9"]];
        [imgv setFrame:CGRectMake(0, 0, 20, 20)];
        
        textField.leftView = imgv;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:postAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)touchVipLoginButton:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *postAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *idCardNumber = alertController.textFields[0].text;
        NSString *phoneNumber = alertController.textFields[1].text;
        [self requestLogin:idCardNumber phone:phoneNumber];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"身份证号";
        UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"64-8"]];
        [imgv setFrame:CGRectMake(0, 0, 20, 20)];
        
        textField.leftView = imgv;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"手机号";
        UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"64-9"]];
        [imgv setFrame:CGRectMake(0, 0, 20, 20)];
        
        textField.leftView = imgv;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:postAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)touchChangeUserButton:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更换用户" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *postAction = [UIAlertAction actionWithTitle:@"更换用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *idCardNumber = alertController.textFields[0].text;
        NSString *phoneNumber = alertController.textFields[1].text;
        [self requestLogin:idCardNumber phone:phoneNumber];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"身份证号";
        UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"64-8"]];
        [imgv setFrame:CGRectMake(0, 0, 20, 20)];
        
        textField.leftView = imgv;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"手机号";
        UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"64-9"]];
        [imgv setFrame:CGRectMake(0, 0, 20, 20)];
        
        textField.leftView = imgv;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:postAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)touchLogoutButton:(id)sender {
    [[ZiZhiUserInfoLocalHelperModel userInfoLocalHelper] logout];
    [self updateUI];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

#pragma mark - Network request
/**
 *  注册接口
 *
 *  @param idcardnumber    身份证号
 *  @param phone   手机号
 */
//    static NSString * const k_url_regist = @"/cctv/client/user/operate/regist.do";
- (void)requestRegist:(NSString *)idCardNumber phone:(NSString *)phone {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([Utils isBlankString:idCardNumber]) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"身份证号不能为空";
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        return;
    }else {
        if (![Utils isIdentityCardNo:idCardNumber]) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"请输入正确的身份证号";
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
            return;
        }
    }
    
    if ([Utils isBlankString:phone]) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"手机号不能为空";
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        return;
    }else {
        if (![Utils isMobileNumber:phone]) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"请输入正确的手机号";
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
            return;
        }
    }

    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:idCardNumber forKey:@"idcardnumber"];
    [params setObject:phone forKey:@"phone"];
    [[ZiZhiNetworkManager sharedManager] post:k_url_regist parameters:params success:^(NSDictionary *dictionary) {
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = model.message;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        
        if(![[ZiZhiUserInfoLocalHelperModel userInfoLocalHelper] isLogin]) {
            [self requestLogin:idCardNumber phone:phone];
        }
        
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = errorMsg;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    }];
}

- (void)requestLogin:(NSString *)idCardNumber phone:(NSString *)phone {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([Utils isBlankString:idCardNumber]) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"身份证号不能为空";
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        return;
    }else {
        if (![Utils isIdentityCardNo:idCardNumber]) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"请输入正确的身份证号";
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
            return;
        }
    }
    
    if ([Utils isBlankString:phone]) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"手机号不能为空";
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        return;
    }else {
        if (![Utils isMobileNumber:phone]) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"请输入正确的手机号";
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
            return;
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:idCardNumber forKey:@"idcardnumber"];
    [params setObject:phone forKey:@"phone"];
    [params setObject:@"ios" forKey:@"devicetype"];
    ZiZhiUserInfoLocalHelperModel *helper = [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper];
    if (helper.bChannerId != nil) {
        [params setObject:helper.bChannerId forKey:@"bchannelid"];
    }
    if (helper.bUserId != nil) {
        [params setObject:helper.bUserId forKey:@"buserid"];
    }
    [[ZiZhiNetworkManager sharedManager] post:k_url_login parameters:params success:^(NSDictionary *dictionary) {
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = model.message;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        if (CodeSuccess == model.httpCode) {
            //本地化
            ZiZhiUserInfoModel *userInfo = [ZiZhiUserInfoModel objectWithKeyValues:[dictionary objectForKey:@"content"]];
            [[ZiZhiUserInfoLocalHelperModel userInfoLocalHelper] login:userInfo];
            [self updateUI];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = errorMsg;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
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

@end
