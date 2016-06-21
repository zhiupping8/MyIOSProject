//
//  ZiZhiApplyTicketViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/2/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiApplyTicketViewController.h"
#import "SDCycleScrollView.h"
#import "BRAdmobView.h"
#import "ZiZhiHomeApplyViewController.h"
#import "ZiZhiHomeVipViewController.h"
#import "ZiZhiBannerItemModel.h"
#import "ZiZhiMainalModel.h"
#import "ZiZhiWebViewController.h"
#import "ZiZhiAfficheModel.h"
#import "MarqueeLabel.h"

@interface ZiZhiApplyTicketViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet MarqueeLabel *announcementLabel;


@property (weak, nonatomic) IBOutlet UIImageView *applyImageView;
@property (weak, nonatomic) IBOutlet UILabel *applyLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UILabel *applyTipsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UIButton *vipButton;
@property (weak, nonatomic) IBOutlet UILabel *vipTipsLabel;

@property (strong, nonatomic) NSArray *afficheArray;
@end

@implementation ZiZhiApplyTicketViewController

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

- (void)addTouchEventToImageView {
    UIGestureRecognizer *gestureRecongnizerApply = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTicketImageView:)];
    self.applyImageView.userInteractionEnabled = YES;
    [self.applyImageView addGestureRecognizer:gestureRecongnizerApply];
    
    UIGestureRecognizer *gestureRecognizerVip = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchVipImageView:)];
    self.vipImageView.userInteractionEnabled = YES;
    [self.vipImageView addGestureRecognizer:gestureRecognizerVip];
}
//{"picpath":"/images/settingpic/9858fbbe-ad49-4df5-bb40-a637228d223b1449407715727.png",
//"tippriceinfo":"免费",
//"tipinfo":"实名认证",
//"tiptip":"中视通票在手 想看啥栏目都有",
//"kuohaotip":"每月限申请一张"}
//初始化或者更新赠票视图
- (void)initMainal:(NSArray *)array {
    if (array.count>=2) {
        ZiZhiMainalModel *ticketModel = (ZiZhiMainalModel *)[array objectAtIndex:0];
        ZiZhiMainalModel *vipModel = (ZiZhiMainalModel *)[array objectAtIndex:1];
        [self.applyImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, ticketModel.picpath]] placeholderImage:[UIImage imageNamed:@"no_img_tip.jpg"]];
        NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(%@)", ticketModel.tipinfo, ticketModel.kuohaotip]];
        [mutableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Heiti SC" size:15.0f] range:NSMakeRange(ticketModel.tipinfo.length, ticketModel.kuohaotip.length+2)];
        self.applyLabel.attributedText = mutableString;
        [self.applyButton setTitle:ticketModel.tippriceinfo forState:UIControlStateNormal];
        self.applyTipsLabel.text = ticketModel.tiptip;
        [self.vipImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, vipModel.picpath]] placeholderImage:[UIImage imageNamed:@"no_img_tip.jpg"]];
        self.vipLabel.text = [NSString stringWithFormat:@"%@", vipModel.tipinfo];
        [self.vipButton setTitle:[NSString stringWithFormat:@"%@元", vipModel.tippriceinfo] forState:UIControlStateNormal];
        self.vipTipsLabel.text = vipModel.tiptip;
    }else {
        CCLog(@"获取赠票列表的数据有误");
    }
}

- (void)initUI {
    [self addTouchEventToImageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    self.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestBanner];
        [self requestMainal];
        [self requestNotList];
    }];
    [self.scrollView.header beginRefreshing];
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
//    webViewController.urlStr = [NSString stringWithFormat:@"%@/cctv%@", K_NETWORK_BASE, model.url];
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

#pragma mark - Network Request
- (void)requestBanner {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:@(1) forKey:@"type"];
    [[ZiZhiNetworkManager sharedManager] get:k_url_advlist parameters:dictionary success:^(NSDictionary *dictionary) {
        [self.scrollView.header endRefreshing];
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            NSArray *array = [ZiZhiBannerItemModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]];
            [self initBanner:array];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        [self.scrollView.header endRefreshing];
        CCLog(@"ZiZhiApplyTicketViewController request banner failed :%@", errorMsg);
    }];
}

- (void)requestMainal {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [[ZiZhiNetworkManager sharedManager] get:k_url_mainal parameters:dictionary success:^(NSDictionary *dictionary) {
        [self.scrollView.header endRefreshing];
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            [hud hide:YES afterDelay:0.0f];
            NSArray *array = [ZiZhiMainalModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]];
            [self initMainal:array];
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
 *  获取公告
 *  @param type=1申请赠票 2栏目报名
 */
//static NSString * const k_url_notlist = @"/client/adv/notlist.do";
- (void)requestNotList {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@(1) forKey:@"type"];
    [[ZiZhiNetworkManager sharedManager] get:k_url_notlist parameters:params success:^(NSDictionary *dictionary) {
        [self.scrollView.header endRefreshing];
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            self.afficheArray = [ZiZhiAfficheModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]];
            //界面处理
            [self updateAfficheUI];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        [self.scrollView.header endRefreshing];
        CCLog(@"request notlist error:%@", errorMsg);
    }];
}

#pragma mark - Touch Event
- (void)touchTicketImageView:(UIGestureRecognizer *)gestureRecognizer{
    CCLog(@"touch ticket imageView");
    ZiZhiHomeApplyViewController *homeApplyViewController = [[ZiZhiHomeApplyViewController alloc] init];
    [self.navigationController pushViewController:homeApplyViewController animated:YES];
}

- (void)touchVipImageView:(UIGestureRecognizer *)gestureRecognizer {
    CCLog(@"touch vip imageView");
    ZiZhiHomeVipViewController *homeVipController = [[ZiZhiHomeVipViewController alloc] init];
    [self.navigationController pushViewController:homeVipController animated:YES];
}
- (IBAction)touchApplyTicketButton:(id)sender {
    ZiZhiHomeApplyViewController *homeApplyViewController = [[ZiZhiHomeApplyViewController alloc] init];
    [self.navigationController pushViewController:homeApplyViewController animated:YES];
}

- (IBAction)touchApplyVipButton:(id)sender {
    ZiZhiHomeVipViewController *homeVipController = [[ZiZhiHomeVipViewController alloc] init];
    [self.navigationController pushViewController:homeVipController animated:YES];
}

@end

