//
//  ZiZhiMyVipViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/9/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiMyVipViewController.h"
#import "ZiZhiMyVipTableViewCell.h"
#import "ZiZhiOrderModel.h"
#import "ZiZhiWebViewController.h"
#import "ZiZhiOrderModel.h"

@interface ZiZhiMyVipViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger page;
@end

@implementation ZiZhiMyVipViewController

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.page = 1;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.tableView.footer resetNoMoreData];
        [self requestList];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestList];
    }];
    
    if ([[ZiZhiUserInfoLocalHelperModel userInfoLocalHelper] isLogin]) {
        [self.tableView.header beginRefreshing];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyToRefresh) name:kMyVipRefreshNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMyVipRefreshNotification object:nil];
}

//申请赠票成功后,刷新列表
- (void)applyToRefresh {
    [self.tableView.header beginRefreshing];
}

- (void)logout {
    self.dataArray = nil;
    [self.tableView reloadData];
}

#pragma mark - Network request
/**
 *  观众评委申请列表
 *
 *  @param idnumber    身份证号
 *  @param page   页码
 *  @param phone 手机号
 */
//static NSString * const k_url_userrater_listinfo = @"/cctv/client/order/userrater/listinfo.do";

- (void)requestList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ZiZhiUserInfoLocalHelperModel *helper = [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper];
    if ([helper isLogin]) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:helper.userInfoModel.idCardNumber forKey:@"idnumber"];
        [params setObject:@(self.page) forKey:@"page"];
        [params setObject:helper.userInfoModel.phone forKey:@"phone"];
        
        [[ZiZhiNetworkManager sharedManager] get:k_url_userrater_listinfo parameters:params success:^(NSDictionary *dictionary) {
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
                [self.dataArray addObjectsFromArray:[ZiZhiOrderModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]]];
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
    }else {
        [self.tableView.header endRefreshing];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请先登录";
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    }
    
}

//- (void)requestlogistics:(NSString *)ticketapplyid logisticno:(NSString *)logisticno{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    [params setObject:ticketapplyid forKey:@"ticketapplyid"];
//    [params setObject:logisticno forKey:@"logisticno"];
//    [[ZiZhiNetworkManager sharedManager] get:k_url_ticket_apply_logistic parameters:params success:^(NSDictionary *dictionary) {
//        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
//        if (CodeSuccess == model.httpCode) {
//            //goto webview
//            //不知道这里是不是需要记性地址拼接
//            [self gotoWebView:model.content];
//        }else {
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = model.message;
//            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
//        }
//    } failure:^(NSInteger errorCode, NSString *errorMsg) {
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = errorMsg;
//        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
//    }];
//}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"ZiZhiMyVipTableViewCell";
    ZiZhiMyVipTableViewCell *cell = (ZiZhiMyVipTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell = [[ZiZhiMyVipTableViewCell alloc] init];
        [tableView registerClass:[ZiZhiMyVipTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    ZiZhiOrderModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.timeLabel.text = model.time;
    cell.statusLabel.text = model.state;
    cell.checkLabel.text = model.message;
    cell.checkLabel.tag = indexPath.row;
    
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCheckLabel:)];
    cell.checkLabel.userInteractionEnabled = YES;
    [cell.checkLabel addGestureRecognizer:gesture];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    ZiZhiProgramSignUpDetailViewController *detailVC = (ZiZhiProgramSignUpDetailViewController *)[Utils getVCFromSB:@"ZiZhiProgramSignUpDetailViewController" storyBoardName:nil];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Touch event
- (void)touchCheckLabel:(UIGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    ZiZhiOrderModel *model = [self.dataArray objectAtIndex:label.tag];
     CCLog(@"model:%@", model.ismylogistic);
    if ([Utils isBlankString:model.ismylogistic]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"暂无信息";
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    }else {
        if ([model.ismylogistic isEqualToString:@"1"]) {
            NSString *url = [NSString stringWithFormat:k_url_vip_apply_logistic, model.orderraterid];
            CCLog(@"orderid:%@", model.orderraterid);
            CCLog(@"url:%@", url);
            [self gotoWebView:url];
        }else if ([model.ismylogistic isEqualToString:@"0"]) {
            NSString *url = [NSString stringWithFormat:k_url_third_logistic, model.logistictype, model.logisticno];
            CCLog(@"logistictype:%@, logisticno:%@", model.logistictype, model.logisticno);
            CCLog(@"url:%@", url);
            [self gotoWebView:url];
        }
    }
}

- (void)gotoWebView:(NSString *)url {
    ZiZhiWebViewController *webVC = (ZiZhiWebViewController *)[Utils getVCFromSB:@"ZiZhiWebViewController" storyBoardName:nil];
    webVC.urlStr = url;
    [self.navigationController pushViewController:webVC animated:YES];
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
