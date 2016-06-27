//
//  ZiZhiEnterpriseTicketViewController.m
//  ZiZhiGZW
//
//  Created by 张Yongzhi on 6/22/16.
//  Copyright © 2016 zizhi. All rights reserved.
//

#import "ZiZhiEnterpriseTicketViewController.h"
#import "MarqueeLabel.h"
#import "ZiZhiBannerItemModel.h"
#import "BRAdmobView.h"
#import "ZiZhiWebViewController.h"
#import "ZiZhiCommodityModel.h"
#import "ZiZhiAfficheModel.h"
#import "ZiZhiCommodityItemTableViewCell.h"
#import "ZiZhiHomeCommodityViewController.h"
#import "ZiZhiCommodityPicGestureRecognizer.h"
#import "ZiZhiMainalModel.h"

#import "ZiZhiHomeVipViewController.h"

@interface ZiZhiEnterpriseTicketViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet MarqueeLabel *announcementLabel;
@property (copy, nonatomic) NSMutableArray *commodityData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSArray *afficheArray;
@end

@implementation ZiZhiEnterpriseTicketViewController

- (NSArray *)commodityData {
    if (!_commodityData) {
        _commodityData = [NSMutableArray new];
    }
    return _commodityData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.commodityData removeAllObjects];
        [self requestBanner];
        [self requestMainal];
        [self requestCommodities];
        [self requestNotList];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestCommodities];
    }];
    [self.tableView.header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {

}

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

- (void)updateAfficheUI {
    if (self.afficheArray.count > 0) {
        ZiZhiAfficheModel *model = [self.afficheArray objectAtIndex:0];
        self.announcementLabel.text = model.notContent;
        self.announcementLabel.marqueeType = MLContinuous;
        self.announcementLabel.rate = 24;
        self.announcementLabel.fadeLength = 10.0f;
        self.announcementLabel.trailingBuffer = 30.0f;
        
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAfficheDetail:)];
        self.announcementLabel.userInteractionEnabled = YES;
        [self.announcementLabel addGestureRecognizer:gesture];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commodityData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"CommodityCellIdentifier";
    ZiZhiCommodityItemTableViewCell *cell = (ZiZhiCommodityItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell = [[ZiZhiCommodityItemTableViewCell alloc] init];
        [tableView registerClass:[ZiZhiCommodityItemTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    if ([self.commodityData count] > 0) {
        if (0 == indexPath.row) {
            ZiZhiMainalModel *mainalModel = (ZiZhiMainalModel *)[self.commodityData objectAtIndex:indexPath.row];
            [cell.commodityPic  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, mainalModel.picpath]] placeholderImage:[UIImage imageNamed:@"no_img_tip.jpg"]];
            cell.commodityTitleLabel.text = mainalModel.tipinfo;
            cell.commodityInfoLabel.text = mainalModel.tiptip;
            [cell.commodityPriceButton setTitle:[NSString stringWithFormat:@"%@元", mainalModel.tippriceinfo] forState:UIControlStateNormal];
            
            //add touch event
            
            ZiZhiCommodityPicGestureRecognizer *gestureRecongnizerCommodity = [[ZiZhiCommodityPicGestureRecognizer alloc] initWithTarget:self action:@selector(touchCommodityImageView:)];
            cell.commodityPic.userInteractionEnabled = YES;
            gestureRecongnizerCommodity.tag = indexPath.row;
            [cell.commodityPic addGestureRecognizer:gestureRecongnizerCommodity];
            
            [cell.commodityPriceButton addTarget:self action:@selector(touchCommodityPriceButton:) forControlEvents:UIControlEventTouchUpInside];
            cell.commodityPriceButton.tag = indexPath.row;
        } else if (indexPath.row >= 1 && [self.commodityData count] > 1) {
            CCLog(@"commodityData:%@", self.commodityData);
            ZiZhiCommodityModel *commodityModel = [self.commodityData objectAtIndex:indexPath.row];
            [cell.commodityPic  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, commodityModel.picpath]] placeholderImage:[UIImage imageNamed:@"no_img_tip.jpg"]];
            cell.commodityTitleLabel.text = commodityModel.tipinfo;
            cell.commodityInfoLabel.text = commodityModel.tiptip;
            [cell.commodityPriceButton setTitle:[NSString stringWithFormat:@"%@元", commodityModel.tippriceinfo] forState:UIControlStateNormal];
            
            //add touch event
            
            ZiZhiCommodityPicGestureRecognizer *gestureRecongnizerCommodity = [[ZiZhiCommodityPicGestureRecognizer alloc] initWithTarget:self action:@selector(touchCommodityImageView:)];
            cell.commodityPic.userInteractionEnabled = YES;
            gestureRecongnizerCommodity.tag = indexPath.row;
            [cell.commodityPic addGestureRecognizer:gestureRecongnizerCommodity];
            
            [cell.commodityPriceButton addTarget:self action:@selector(touchCommodityPriceButton:) forControlEvents:UIControlEventTouchUpInside];
            cell.commodityPriceButton.tag = indexPath.row;
        }

    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    ZiZhiProgramSignUpDetailViewController *detailVC = (ZiZhiProgramSignUpDetailViewController *)[Utils getVCFromSB:@"ZiZhiProgramSignUpDetailViewController" storyBoardName:nil];
    if (0 == indexPath.row) {
        ZiZhiHomeVipViewController *homeVipViewController = [[ZiZhiHomeVipViewController alloc] init];
        [self.navigationController pushViewController:homeVipViewController animated:YES];
    } else {
        ZiZhiHomeCommodityViewController *homeCommodityViewController = [[ZiZhiHomeCommodityViewController alloc] init];
        ZiZhiCommodityModel *commodityModel = [self.commodityData objectAtIndex:indexPath.row];
        homeCommodityViewController.goodid = commodityModel.goodid;
        [self.navigationController pushViewController:homeCommodityViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Touch Event
- (void)touchCommodityImageView:(UIGestureRecognizer *)gestureRecognizer{
    CCLog(@"touch commodity imageView");
    ZiZhiCommodityPicGestureRecognizer *commodityPicGestureRecognizer = (ZiZhiCommodityPicGestureRecognizer *)gestureRecognizer;
    if (0 == commodityPicGestureRecognizer.tag) {
        ZiZhiHomeVipViewController *homeVipViewController = [[ZiZhiHomeVipViewController alloc] init];
        [self.navigationController pushViewController:homeVipViewController animated:YES];
    } else {
        ZiZhiHomeCommodityViewController *homeCommodityViewController = [[ZiZhiHomeCommodityViewController alloc] init];
        ZiZhiCommodityModel *commodityModel = [self.commodityData objectAtIndex:commodityPicGestureRecognizer.tag];
        homeCommodityViewController.goodid = commodityModel.goodid;
        [self.navigationController pushViewController:homeCommodityViewController animated:YES];
    }
}

- (void)touchCommodityPriceButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (0 == button.tag) {
        ZiZhiHomeVipViewController *homeVipViewController = [[ZiZhiHomeVipViewController alloc] init];
        [self.navigationController pushViewController:homeVipViewController animated:YES];
    } else {
        ZiZhiHomeCommodityViewController *homeCommodityViewController = [[ZiZhiHomeCommodityViewController alloc] init];
        ZiZhiCommodityModel *commodityModel = [self.commodityData objectAtIndex:button.tag];
        homeCommodityViewController.goodid = commodityModel.goodid;
        [self.navigationController pushViewController:homeCommodityViewController animated:YES];
    }
}

- (void)gotoAfficheDetail:(UIGestureRecognizer *)gesture {
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

#pragma mark - Network Request
- (void)requestBanner {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:@(1) forKey:@"type"];
    [[ZiZhiNetworkManager sharedManager] get:k_url_advlist parameters:dictionary success:^(NSDictionary *dictionary) {
        [self.tableView.header endRefreshing];
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            NSArray *array = [ZiZhiBannerItemModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]];
            [self initBanner:array];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        [self.tableView.header endRefreshing];
        CCLog(@"ZiZhiApplyTicketViewController request banner failed :%@", errorMsg);
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
        [self.tableView.header endRefreshing];
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            self.afficheArray = [ZiZhiAfficheModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]];
            //界面处理
            [self updateAfficheUI];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        [self.tableView.header endRefreshing];
        CCLog(@"request notlist error:%@", errorMsg);
    }];
}

- (void)requestCommodities {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary new];
    if ([self.commodityData count] > 1) {
        ZiZhiCommodityModel *commodityModel = [self.commodityData objectAtIndex:1];
        NSString *existids = commodityModel.goodid;
        for(int i = 2; i < [self.commodityData count]; i++) {
            ZiZhiCommodityModel *commodityModel = [self.commodityData objectAtIndex:i];
            existids = [existids stringByAppendingString:[NSString stringWithFormat:@",%@", commodityModel.goodid]];
        }
        [params setObject:existids forKey:@"existids"];
    }
    
    [[ZiZhiNetworkManager sharedManager] get:k_url_commodity_list parameters:params success:^(NSDictionary *dictionary) {
        [self.tableView.header endRefreshing];
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            [hud hide:YES afterDelay:0.0f];
            [self.commodityData addObjectsFromArray:[ZiZhiCommodityModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]]];
            [self.tableView reloadData];
        } else {
            if (CodeNoData == model.httpCode) {
                [self.tableView.footer noticeNoMoreData];
            }
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = model.message;
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        [self.tableView.footer endRefreshing];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = errorMsg;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    }];
}

- (void)requestMainal {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [[ZiZhiNetworkManager sharedManager] get:k_url_mainal parameters:dictionary success:^(NSDictionary *dictionary) {
        [self.tableView.header endRefreshing];
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            [hud hide:YES afterDelay:0.0f];
            NSArray *array = [ZiZhiMainalModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]];
            ZiZhiMainalModel *vipModel = (ZiZhiMainalModel *)[array objectAtIndex:1];
            [self.commodityData insertObject:vipModel atIndex:0];
            [self.tableView reloadData];
        }else {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = model.message;
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        [self.tableView.header endRefreshing];
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
