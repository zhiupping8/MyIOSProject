//
//  ZiZhiMyTicketViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/9/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiMyTicketViewController.h"
#import "ZiZhiMyTicketTableViewCell.h"
#import "ZiZhiTicketApplyModel.h"
#import "ZiZhiWebViewController.h"

@interface ZiZhiMyTicketViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger page;
@end

@implementation ZiZhiMyTicketViewController

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)initUI {
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyToRefresh) name:kMyTicketRefreshNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMyTicketRefreshNotification object:nil];
}

//申请赠票成功后,刷新列表
- (void)applyToRefresh {
    [self.tableView.header beginRefreshing];
}

- (void)logout {
    self.dataArray = nil;
    [self.tableView reloadData];
}

/**
 *  查看赠票列表信息
 *
 *  @param idcardnumber    身份证号
 *  @param page   页码
 */
//static NSString * const k_url_apply_infolist = @"/cctv/client/ticket/apply/infolist.do";
#pragma mark - Network request
- (void)requestList {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ZiZhiUserInfoLocalHelperModel *helper = [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper];
    if ([helper isLogin]) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:helper.userInfoModel.idCardNumber forKey:@"idcardnumber"];
        [params setObject:@(self.page) forKey:@"page"];
        //    [params setObject:helper.userInfoModel.phone forKey:@"phone"];
        
        [[ZiZhiNetworkManager sharedManager] get:k_url_apply_infolist parameters:params success:^(NSDictionary *dictionary) {
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
                [self.dataArray addObjectsFromArray:[ZiZhiTicketApplyModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]]];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"ZiZhiMyTicketTableViewCell";
    ZiZhiMyTicketTableViewCell *cell = (ZiZhiMyTicketTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[ZiZhiMyTicketTableViewCell alloc] init];
        [tableView registerClass:[ZiZhiMyTicketTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    ZiZhiTicketApplyModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.timeLabel.text = model.time;
    cell.statusLabel.text = model.state;
    cell.checkLabel.text = model.message;
    
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCheckLabel:)];
    cell.checkLabel.userInteractionEnabled = YES;
    cell.checkLabel.tag = indexPath.row;
    [cell.checkLabel addGestureRecognizer:gesture];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Touch event
- (void)touchCheckLabel:(UIGestureRecognizer *)gesture {
    ZiZhiTicketApplyModel *model = [self.dataArray objectAtIndex:gesture.view.tag];
    CCLog(@"ismy:%@", model.ismylogistic);
    if ([Utils isBlankString:model.ismylogistic]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"暂无信息";
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    }else {
        if ([model.ismylogistic isEqualToString:@"1"]) {
            NSString *url = [NSString stringWithFormat:k_url_ticket_apply_logistic, model.orderid];
            [self gotoWebView:url];
        }else if ([model.ismylogistic isEqualToString:@"0"]) {
            NSString *url = [NSString stringWithFormat:k_url_third_logistic, model.logistictype, model.logisticno];
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
