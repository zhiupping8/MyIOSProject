//
//  ZiZhiProgramSignUpViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/8/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiProgramSignUpViewController.h"
#import "ZiZhiProgramSignUpTableViewCell.h"
#import "ZiZhiBannerItemModel.h"
#import "BRAdmobView.h"
//#import "ZiZhiProgramSignUpDetailViewController.h"
#import "ZiZhiHomeProgramViewController.h"
#import "ZiZhiWebViewController.h"

#import "ZiZhiProgramListItemModel.h"

#import "ZiZhiAfficheModel.h"

#import "MarqueeLabel.h"
@interface ZiZhiProgramSignUpViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *dataArray;


@property (weak, nonatomic) IBOutlet MarqueeLabel *announcementLabel;
@property (strong, nonatomic) NSArray *afficheArray;
@end

@implementation ZiZhiProgramSignUpViewController

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)initBanner:(NSArray *)array {
    NSMutableArray *items = [NSMutableArray new];
    for (ZiZhiBannerItemModel *model in array) {
        AdmobInfo *info = [[AdmobInfo alloc] init];
        info.admobId = model.id;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.page = 1;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 235;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestBanner];
        [self requestNotList];
        self.page = 1;
        [self.tableView.footer resetNoMoreData];
        [self requestMainpl];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestMainpl];
    }];
    [self.tableView.header beginRefreshing];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network Request
- (void)requestBanner {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:@(2) forKey:@"type"];
    [[ZiZhiNetworkManager sharedManager] get:k_url_advlist parameters:dictionary success:^(NSDictionary *dictionary) {
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            NSArray *array = [ZiZhiBannerItemModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]];
            [self initBanner:array];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        CCLog(@"ZiZhiProgramSignUpViewController request banner failed :%@", errorMsg);
    }];
}

/**
 *  首页栏目报名列表
 *  @param page 页码从1开始
 */
//static NSString * const k_url_program_mainpl = @"/cctv/client/program/mainpl.do";

- (void)requestMainpl {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@(self.page) forKey:@"page"];
    [[ZiZhiNetworkManager sharedManager] get:k_url_program_mainpl parameters:params success:^(NSDictionary *dictionary) {
        if (1 == self.page) {
            [self.tableView.header endRefreshing];
        }else {
            [self.tableView.footer endRefreshing];
        }
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            [hud hide:YES];
            if (1 == self.page) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:[ZiZhiProgramListItemModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]]];
            [self.tableView reloadData];
            self.page += 1;
        }else {
            if (CodeNoData == model.httpCode) {
                [self.tableView.footer noticeNoMoreData];
            }
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = model.message;
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        if (1 == self.page) {
            [self.tableView.header endRefreshing];
        }else {
            [self.tableView.footer endRefreshing];
        }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"ReuseIdentifier";
    ZiZhiProgramSignUpTableViewCell *cell = (ZiZhiProgramSignUpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell = [[ZiZhiProgramSignUpTableViewCell alloc] init];
        [tableView registerClass:[ZiZhiProgramSignUpTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    ZiZhiProgramListItemModel *itemModel = (ZiZhiProgramListItemModel *)[self.dataArray objectAtIndex:indexPath.row];
    
    [cell.bigImageView  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, itemModel.programPicPath]] placeholderImage:[UIImage imageNamed:@"no_img_tip.jpg"]];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, itemModel.logoPicPath]] placeholderImage:[UIImage imageNamed:@"no_img_tip.jpg"]];
    [cell.statusButton setTitle:itemModel.state forState:UIControlStateNormal];
    [cell.statusButton addTarget:self action:@selector(touchStatusButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.statusButton.tag = indexPath.row;
    cell.recordTimeLabel.text = [NSString stringWithFormat:@"录制时间:%@", itemModel.time];
    cell.locationLabel.text = [NSString stringWithFormat:@"录制地点:%@", itemModel.address];
    cell.requireLabel.text = [NSString stringWithFormat:@"观众要求:%@", itemModel.audienceRequest];
    
    //add touch event
    cell.bigImageView.userInteractionEnabled = YES;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ZiZhiProgramSignUpDetailViewController *detailVC = (ZiZhiProgramSignUpDetailViewController *)[Utils getVCFromSB:@"ZiZhiProgramSignUpDetailViewController" storyBoardName:nil];
    ZiZhiHomeProgramViewController *homeProgramVC = [[ZiZhiHomeProgramViewController alloc] init];
    ZiZhiProgramListItemModel *itemModel = (ZiZhiProgramListItemModel *)[self.dataArray objectAtIndex:indexPath.row];
    [homeProgramVC setValue:itemModel.programid forKey:@"programId"];
    [self.navigationController pushViewController:homeProgramVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Touch Event 
- (void)touchStatusButton:(UIButton *)sender {
    ZiZhiHomeProgramViewController *homeProgramVC = [[ZiZhiHomeProgramViewController alloc] init];
    ZiZhiProgramListItemModel *itemModel = (ZiZhiProgramListItemModel *)[self.dataArray objectAtIndex:sender.tag];
    [homeProgramVC setValue:itemModel.programid forKey:@"programId"];
    [self.navigationController pushViewController:homeProgramVC animated:YES];
}

@end
