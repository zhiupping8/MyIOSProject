//
//  ZiZhiPayShowViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/18/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiPayShowViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ZiZhiWeiXinPayModel.h"
#import "WXApi.h"
#import "ZiZhiPayViewValueModel.h"

@interface ZiZhiPayShowViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation ZiZhiPayShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cctv_log"]];
    imageView.frame = CGRectMake(0, 0, 120, 37);
    self.navigationItem.titleView = imageView;
    
    CGRect rect = self.navigationController.navigationBar.bounds;
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, rect.size.height-3, rect.size.width, 3)];
    barImageView.image = [UIImage imageNamed:@"bar"];
    [self.navigationController.navigationBar addSubview:barImageView];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.selectedIndex = 0;
    ZiZhiPayViewValueModel *payViewNeedModel = [ZiZhiPayViewValueModel sharedModel];
    
    self.detailLabel.numberOfLines = 0;//表示label可以多行显示
    self.detailLabel.lineBreakMode = UILineBreakModeCharacterWrap;//换行模式，与上面的计算保持一致。
    self.detailLabel.frame = CGRectMake(self.detailLabel.frame.origin.x, self.detailLabel.frame.origin.y, self.detailLabel.frame.size.width, 42);
    self.detailLabel.text = payViewNeedModel.detail;
    
    CCLog(@"view detail:%@", payViewNeedModel.detail);
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", payViewNeedModel.price];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiXinPaySuccess) name:kWeiXinPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiXinPayFail) name:kWeiXinPayFail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipaySuccess:) name:kALiPaySuccess2 object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeiXinPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeiXinPayFail object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kALiPaySuccess2 object:nil];
}

#pragma mark - Table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseCell"];
    if (0 == indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:@"zhifubao_img"];
        cell.textLabel.text = @"支付宝客户端支付";
        cell.detailTextLabel.text = @"推荐安装支付宝客户端的用户使用";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        if (0 == self.selectedIndex) {
            imageView.image = [UIImage imageNamed:@"checkbox_pressed"];
        }else {
            imageView.image = [UIImage imageNamed:@"checkbox_normal"];
        }
        cell.accessoryView = imageView;
    }else if (1 == indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:@"weixin_img"];
        cell.textLabel.text = @"微信支付";
        cell.detailTextLabel.text = @"推荐已安装微信的用户使用";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        if (1 == self.selectedIndex) {
            imageView.image = [UIImage imageNamed:@"checkbox_pressed"];
        }else {
            imageView.image = [UIImage imageNamed:@"checkbox_normal"];
        }
        cell.accessoryView = imageView;
    }
    return cell;
}

#pragma mark - Tabel view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
}

#pragma mark - Network request
/**
 *  支付信息获取
 *
 *  @param ordernumber   订单号
 *  @param paytype    支付类型（1支付宝  2微信）
 */
//static NSString * const k_url_userrater_payinfo = @"/cctv/client/order/userrater/payinfo.do";

- (void)requestPayInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary new];
    ZiZhiPayViewValueModel *payViewNeedModel = [ZiZhiPayViewValueModel sharedModel];
    [params setObject:payViewNeedModel.orderId forKey:@"ordernumber"];
    [params setObject:@(self.selectedIndex + 1) forKey:@"paytype"];
    [[ZiZhiNetworkManager sharedManager] post:k_url_commodity_payinfo parameters:params success:^(NSDictionary *dictionary) {
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        CCLog(@"dictionary:%@", dictionary);
        if (CodeSuccess == model.httpCode) {
            [hud hide:YES];
            
            //发起支付
            if (0 == self.selectedIndex) {
                [self doALiPay:model.content];
            }else if(1 == self.selectedIndex) {
                [self doWeiXinPay:[ZiZhiWeiXinPayModel objectWithKeyValues:[dictionary objectForKey:@"content"]]];
            }
            
        }else {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = model.message;
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = errorMsg;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
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

- (void)alipaySuccess:(NSNotification *)notification {
    NSDictionary *resultDic = notification.object;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CCLog(@"dic:%@", resultDic);
    if([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText= @"支付成功";
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        
        //申请成功，后自动登录（如果本地已经登录则不替换）
        if ([[ZiZhiUserInfoLocalHelperModel userInfoLocalHelper] isLogin]) {
            //刷新我的报名列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kMyVipRefreshNotification object:nil];
        }else {
            ZiZhiPayViewValueModel *payViewNeedModel = [ZiZhiPayViewValueModel sharedModel];
//            NSMutableDictionary *dictionary = [NSMutableDictionary new];
//            [dictionary setObject:payViewNeedModel.idcardnumber forKey:@"idcardnumber"];
//            [dictionary setObject:payViewNeedModel.phone forKey:@"phone"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:dictionary];
            [self requestLogin:payViewNeedModel.idcardnumber phone:payViewNeedModel.phone];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"支付失败";
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    }
}

- (void)doALiPay:(NSString *)content {
    NSString *appScheme = @"com.cctv.zsgz";
    NSString *orderString = [content stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    CCLog(@"orderString:%@", orderString);
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        //        NSLog(@"reslut = %@",resultDic[@"memo"]);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        CCLog(@"dic:%@", resultDic);
        if([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"支付成功";
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kALiPaySuccess object:resultDic];
        }else {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"支付失败";
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        }
    }];
}

-(void)doWeiXinPay:(ZiZhiWeiXinPayModel *)payModel{
    BOOL isOk1 = [WXApi registerApp:payModel.appId withDescription:@"cctvgz2.0"];
    if(!isOk1){
        CCLog(@"微信支付注册失败");
    }
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = payModel.partnerId;
    request.prepayId= payModel.prepayId;
    request.package = payModel.packageValue;
    request.nonceStr= payModel.nonceStr;
    request.timeStamp = [payModel.timeStamp integerValue];
    request.sign= payModel.sign;
    CCLog(@"partnerId:%@", payModel.partnerId);
    BOOL isOk =  [WXApi sendReq:request];
    if(!isOk){
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:@"支付失败" message:@"没有安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
}

- (void)weiXinPaySuccess {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = @"支付成功";
    [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)weiXinPayFail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = @"支付失败";
    [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)touchPayButton:(id)sender {
    [self requestPayInfo];
}


@end
