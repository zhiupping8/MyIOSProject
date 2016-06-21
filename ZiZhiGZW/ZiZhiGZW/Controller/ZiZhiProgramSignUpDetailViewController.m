//
//  ZiZhiProgramSignUpDetailViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/8/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiProgramSignUpDetailViewController.h"
#import "ZiZhiBannerItemModel.h"
#import "BRAdmobView.h"
#import "ZiZhiProgramDetailModel.h"
#import "ZiZhiChooseTimeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ZiZhiWebViewController.h"
#import "ZiZhiAfficheModel.h"
#import "MarqueeLabel.h"

@interface ZiZhiProgramSignUpDetailViewController ()<UITextFieldDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *secretTextField;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UILabel *requireLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locateImageView;

@property (weak, nonatomic) IBOutlet UIButton *chooseTimeButton;
@property (strong, nonatomic) ZiZhiProgramDetailModel *programDetailModel;

@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MarqueeLabel *announcementLabel;
@property (strong, nonatomic) NSArray *afficheArray;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger firstTag;
@end

@implementation ZiZhiProgramSignUpDetailViewController

- (void)initBanner:(NSArray *)array {
    NSMutableArray *items = [NSMutableArray new];
    for (ZiZhiBannerItemModel *model in array) {
        AdmobInfo *info = [[AdmobInfo alloc] init];
        info.admobId = [NSString stringWithFormat:@"%@", model.id];
        info.url = [NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, model.picture];
        info.defultImage = [UIImage imageNamed:@"no_img_tip.jpg"];
        [items addObject:info];
    }
    BRAdmobView *banner = [[BRAdmobView alloc] initWithFrame:self.bannerView.bounds andData:items andInViewe:self.bannerView];
    [banner addPageControlViewWithSize:CGSizeMake(10, 10) WithPostion:KPageControlPostion_Middle];
    banner.isAutoScoller=YES;
    banner.allowSelect = YES;
    banner.admobSelect=^(id info, NSInteger index){
        ZiZhiBannerItemModel *model = [array objectAtIndex:index];
        ZiZhiWebViewController *webVC = (ZiZhiWebViewController *)[Utils getVCFromSB:@"ZiZhiWebViewController" storyBoardName:nil];
//        webVC.urlStr = [NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, model.url];
        if ([model.url hasPrefix:@"http"]) {
            webVC.urlStr = model.url;
        }else {
            webVC.urlStr = [NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, model.url];
        }
        [self.navigationController pushViewController:webVC animated:YES];
    };
    for (UIView *view in [self.bannerView subviews]) {
        [view removeFromSuperview];
    }
    [self.bannerView addSubview:banner];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTag = 0;
    self.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestBanner];
        [self requestDetail];
        [self requestNotList];
    }];
    [self.scrollView.header beginRefreshing];

    
    self.selectedIndex = -1;
    self.phoneButton.userInteractionEnabled = NO;
    self.nameTextField.delegate = self;
    self.idCardTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.secretTextField.delegate = self;
    
    if ([[ZiZhiUserInfoLocalHelperModel userInfoLocalHelper] isLogin]) {
        self.idCardTextField.text = [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper].userInfoModel.idCardNumber;
        self.phoneTextField.text = [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper].userInfoModel.phone;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoAfficheDetail {
    if ([self.announcementLabel isPaused]) {
        [self.announcementLabel unpauseLabel];
    }
    
    ZiZhiAfficheModel *model = [self.afficheArray objectAtIndex:0];
    ZiZhiWebViewController *webViewController = (ZiZhiWebViewController *)[Utils getVCFromSB:@"ZiZhiWebViewController" storyBoardName:nil];
//    webViewController.urlStr = [NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, model.url];
    if ([model.url hasPrefix:@"http"]) {
        webViewController.urlStr = model.url;
    }else {
        webViewController.urlStr = [NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, model.url];
    }
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)updateAfficheUI {
    if (self.afficheArray.count > 0) {
        ZiZhiAfficheModel *model = [self.afficheArray objectAtIndex:0];
        self.announcementLabel.text = model.notContent;
        self.announcementLabel.marqueeType = MLContinuous;
        self.announcementLabel.rate = 24;
        self.announcementLabel.fadeLength = 10.0f;
        self.announcementLabel.trailingBuffer = 30.0f;
        
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAfficheDetail)];
        self.announcementLabel.userInteractionEnabled = YES;
        [self.announcementLabel addGestureRecognizer:gesture];
    }
}

- (void)touchLocateImageView:(UIGestureRecognizer *)gesture {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    [self.locationManager startUpdatingLocation];
}

- (IBAction)touchPhoneButton:(UIButton *)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",sender.titleLabel.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

/**
 *  <#Description#>
 *
 *  @param model <#model description#>
 */
- (void)updateUI:(ZiZhiProgramDetailModel *)model {
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, model.logoPicPath]] placeholderImage:[UIImage imageNamed:@"no_img_tip.jpg"]];
    
    if (self.programDetailModel.records.count > 0) {
        self.selectedIndex = 0;
        ZiZhiRecordModel *model = [self.programDetailModel.records objectAtIndex:self.selectedIndex];
        if (0 == self.firstTag) {
        }else {
            [self.chooseTimeButton setTitle:model.recordtime forState:UIControlStateNormal];
        }
        [self updateProgramInfoUI];
    }
    
}

- (void)loadWebView:(NSString *)urlStr {
    if (urlStr != nil) {
        NSURL *url = [[NSURL alloc]initWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];//默认缓存策略
        [self.webView loadRequest:request];
    }else {
        self.webView.hidden = YES;
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -self.webView.frame.size.height, 0);
    }
    
}

- (void)updateProgramInfoUI {
    ZiZhiRecordModel *model = [self.programDetailModel.records objectAtIndex:self.selectedIndex];
    self.addressLabel.text = [NSString stringWithFormat:@"录制地点:%@", model.recordaddress];
    self.contactLabel.text = [NSString stringWithFormat:@"现场联系人:%@", model.contactname];
    [self.phoneButton setTitle:model.contactphone forState:UIControlStateNormal];
    
    self.requireLabel.numberOfLines = 0;//表示label可以多行显示
    self.requireLabel.lineBreakMode = UILineBreakModeCharacterWrap;//换行模式，与上面的计算保持一致。
    self.requireLabel.frame = CGRectMake(self.requireLabel.frame.origin.x, self.requireLabel.frame.origin.y, self.requireLabel.frame.size.width, 42);
    self.requireLabel.text = [NSString stringWithFormat:@"观众要求:%@", model.audiencerequest];
    
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchLocateImageView:)];
    self.locateImageView.userInteractionEnabled = YES;
    [self.locateImageView addGestureRecognizer:gesture];
    self.phoneButton.userInteractionEnabled = YES;
    
    [self loadWebView:[NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, model.contentimgpath]];
}

#pragma mark - Network Request
- (void)requestBanner {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:@(2) forKey:@"type"];
    [[ZiZhiNetworkManager sharedManager] get:k_url_advlist parameters:dictionary success:^(NSDictionary *dictionary) {
        [self.scrollView.header endRefreshing];
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            NSArray *array = [ZiZhiBannerItemModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]];
            [self initBanner:array];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        [self.scrollView.header endRefreshing];
        CCLog(@"ZiZhiProgramSignUpDetailViewController request banner failed :%@", errorMsg);
    }];
}

/**
 *  栏目报名详情
 *  @param programid 栏目id
 */
//static NSString * const k_url_program_detail = @"/cctv/client/program/detail.do";

- (void)requestDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.programId forKey:@"programid"];
    [[ZiZhiNetworkManager sharedManager] get:k_url_program_detail parameters:params success:^(NSDictionary *dictionary) {
        [self.scrollView.header endRefreshing];
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            [hud hide:YES];
            self.programDetailModel = [ZiZhiProgramDetailModel objectWithKeyValues:[dictionary objectForKey:@"content"]];
            [self updateUI:self.programDetailModel];
        }else {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = model.message;
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        [self.scrollView.header endRefreshing];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = errorMsg;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    }];
}

/**
 *  节目报名
 *
 *  @param name   姓名
 *  @param idcardnumber    身份证号
 *  @param phone   手机号
 *  @param secretkey
 *  @param programupdateid   节目id
 *  @param loginedidcardnumber
 */
//static NSString * const k_url_program_enroll = @"/cctv/client/program/enroll.do";
- (void)requestEnroll {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *name = self.nameTextField.text;
    NSString *idCardNumber = self.idCardTextField.text;
    NSString *phone = self.phoneTextField.text;
    NSString *secretKey = self.secretTextField.text;
    ZiZhiUserInfoLocalHelperModel *helper = [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper];

    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:name forKey:@"name"];
    [params setObject:idCardNumber forKey:@"idcardnumber"];
    if (![Utils isBlankString:secretKey]) {
        [params setObject:secretKey forKey:@"secretkey"];
    }
    [params setObject:phone forKey:@"phone"];
    ZiZhiRecordModel *model = [self.programDetailModel.records objectAtIndex:self.selectedIndex];
    [params setValue:model.programupdateid forKey:@"programupdateid"];
    if ([helper isLogin]) {
       [params setObject:helper.userInfoModel.idCardNumber forKey:@"loginedidcardnumber"]; 
    }
    
    [[ZiZhiNetworkManager sharedManager] post:k_url_program_enroll parameters:params success:^(NSDictionary *dictionary) {
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = model.message;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        
        //申请成功，后自动登录（如果本地已经登录则不替换）
        if ([[ZiZhiUserInfoLocalHelperModel userInfoLocalHelper] isLogin]) {
            //刷新我的报名列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kSignUpRefreshNotification object:nil];
        }else {
//            NSMutableDictionary *dictionary = [NSMutableDictionary new];
//            [dictionary setObject:idCardNumber forKey:@"idcardnumber"];
//            [dictionary setObject:phone forKey:@"phone"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:dictionary];
            [self requestLogin:idCardNumber phone:phone];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = errorMsg;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    }];
}

- (void)requestNotList {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@(2) forKey:@"type"];
    [[ZiZhiNetworkManager sharedManager] get:k_url_notlist parameters:params success:^(NSDictionary *dictionary) {
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            self.afficheArray = [ZiZhiAfficheModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]];
            //界面处理
            [self updateAfficheUI];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        CCLog(@"request notlist error:%@", errorMsg);
    }];
}

- (void)requestLogin:(NSString *)idCardNumber phone:(NSString *)phone {
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
        if (CodeSuccess == model.httpCode) {
            //本地化
            ZiZhiUserInfoModel *userInfo = [ZiZhiUserInfoModel objectWithKeyValues:[dictionary objectForKey:@"content"]];
            [[ZiZhiUserInfoLocalHelperModel userInfoLocalHelper] login:userInfo];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
    }];
}

- (IBAction)touchSignUpButton:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.idCardTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.secretTextField resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *name = self.nameTextField.text;
    NSString *idCardNumber = self.idCardTextField.text;
    NSString *phone = self.phoneTextField.text;
//    NSString *secretKey = self.secretTextField.text;
    if ([Utils isBlankString:name]) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"姓名不能为空";
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        return;
    }
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
    if (0 == self.firstTag) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请选择录制时间";
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        return;
    }
//    if ([Utils isBlankString:secretKey]) {
//        hud.mode = MBProgressHUDModeText;
//        hud.detailsLabelText = @"密钥不能为空";
//        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
//        return;
//    }
    [hud hide:YES];
    [self requestEnroll];
}

#pragma mark - TextField method
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (IBAction)touchChooseTimeButton:(id)sender {
    ZiZhiChooseTimeViewController *chooseTimeVC = [[ZiZhiChooseTimeViewController alloc] init];
    chooseTimeVC.records = self.programDetailModel.records;
    chooseTimeVC.selectedIndex = self.selectedIndex;
    chooseTimeVC.returnInfoBlock = ^(NSInteger selectedIndex,NSString *timeText){
        self.selectedIndex = selectedIndex;
        if (self.selectedIndex != -1) {
            self.firstTag = 1;
            [self.chooseTimeButton setTitle:timeText forState:UIControlStateNormal];
            [self updateProgramInfoUI];
        }
    };
    [self.navigationController pushViewController:chooseTimeVC animated:YES];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}
// 地理位置发生改变时触发
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"在这里吗");
    
    UIViewController *vc = [[UIViewController alloc]init];
    [vc.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    vc.title = @"导航";
    
    NSString *startLng = [NSString stringWithFormat:@"%f",((CLLocation*)[locations lastObject]).coordinate.longitude];
    NSString *startLat = [NSString stringWithFormat:@"%f",((CLLocation*)[locations lastObject]).coordinate.latitude];
    
    // 停止位置更新
    [manager stopUpdatingLocation];
    ZiZhiRecordModel *model = [self.programDetailModel.records objectAtIndex:self.selectedIndex];
    NSString *endLng = [NSString stringWithFormat:@"%f",model.lng];
    NSString *endLat = [NSString stringWithFormat:@"%f",model.lat];
    //    NSString *endLng = (NSString *)self.detaiInfoDic[@"ProgramUpdateRecord"][@"Lng"];
    //    NSString *endLat = (NSString *)self.detaiInfoDic[@"ProgramUpdateRecord"][@"Lat"];
    
    UIWebView *webView=[[UIWebView alloc] initWithFrame:vc.view.frame];
    [vc.view addSubview:webView];
    [webView setBackgroundColor:[UIColor whiteColor]];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"map" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{{key}}" withString:@"wQGoMC1fr3uDpk43k22f5CDc"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{{p1x}}" withString:startLng];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{{p1y}}" withString:startLat];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{{p2x}}" withString:endLng];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{{p2y}}" withString:endLat];
    
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    NSLog(@"htmlString:%@",htmlString);
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
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
