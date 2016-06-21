//
//  ZiZhiSettingViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/7/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiSettingViewController.h"
#import "ZiZhiSettingModel.h"
#import "ZiZhiWebViewController.h"
#import "BPush.h"

@interface ZiZhiSettingViewController ()

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) ZiZhiSettingModel *settingModel;

@end

@implementation ZiZhiSettingViewController


- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"设置", @"推送设置", @"喜欢我们，给个好评", @"有问题，反馈意见", @"中视观众", @"帮助"];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self requestSetting];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  获取设置页面信息
 */
//static NSString * const k_url_setting_setting = @"/cctv/client/setting/setting.do";
#pragma mark - Network request
- (void)requestSetting {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [[ZiZhiNetworkManager sharedManager] get:k_url_setting_setting parameters:params success:^(NSDictionary *dictionary) {
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        if (CodeSuccess == model.httpCode) {
            self.settingModel = [ZiZhiSettingModel objectWithKeyValues:[dictionary objectForKey:@"content"]];
        }
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        CCLog(@"request setting error:%@", errorMsg);
    }];
}

/**
 *  意见反馈
 *
 *  @param userid   用户id
 *  @param content    意见内容
 */
//static NSString * const k_url_prize_feedback = @"/cctv/client/user/operate/prize/feedback.do";

- (void)requestFeedBack:(NSString *)content {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ZiZhiUserInfoLocalHelperModel *helper = [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:helper.userInfoModel.id forKey:@"userid"];
    [params setObject:content forKey:@"content"];
    [[ZiZhiNetworkManager sharedManager] post:k_url_prize_feedback parameters:params success:^(NSDictionary *dictionary) {
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = model.message;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = errorMsg;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    }];
}

/**
 *  好评
 *
 *  @param userid   用户id
 *  @param content    评价内容
 *  @param pdegree
 */
//static NSString * const k_url_prize_goodprize = @"/cctv/client/user/operate/prize/goodprize.do";

- (void)requestGoodPrize:(NSString *)content pdegree:(NSString *)pdegree{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ZiZhiUserInfoLocalHelperModel *helper = [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:helper.userInfoModel.id forKey:@"userid"];
    [params setObject:content forKey:@"content"];
    [params setObject:pdegree forKey:@"pdegree"];
    [[ZiZhiNetworkManager sharedManager] post:k_url_prize_goodprize parameters:params success:^(NSDictionary *dictionary) {
        ZiZhiNetworkResponseModel *model = [ZiZhiNetworkResponseModel objectWithKeyValues:dictionary];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = model.message;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    } failure:^(NSInteger errorCode, NSString *errorMsg) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = errorMsg;
        [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
    }];
}

#pragma mark - Target Action
- (void)switchChanged:(UISwitch *)sender {
    //百度设置
    if(sender.on){
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"kPushSetting"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
            // 绑定返回值
        }];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"kPushSetting"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
            // 解绑返回值
        }];
    }
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    if (0 == indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:@"64-5"];
    }else if (1 == indexPath.row) {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchView.on = YES;
        cell.accessoryView = switchView;
        
        //根据本地数据设置switchView的值
        
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        
    }else if (1 == indexPath.row) {
        
    }
//    else if (2 == indexPath.row) {
//        //检测升级
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/zhong-shi-guan-zhong/id1070760630?ls=1&mt=8"]];
//    }
    else if (2 == indexPath.row) {
        //喜欢我们，给个好评
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/qq/id444934666?mt=8"]];
        [self goodPrize];
    }else if (3 == indexPath.row) {
        //反馈意见
        [self feedBack];
    }else if (4 == indexPath.row) {
        ZiZhiWebViewController *webVC = (ZiZhiWebViewController *)[Utils getVCFromSB:@"ZiZhiWebViewController" storyBoardName:nil];
        webVC.navigationItemtitle = @"中视观众";
        webVC.urlStr = [NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, self.settingModel.introducepage];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (5 == indexPath.row) {
        ZiZhiWebViewController *webVC = (ZiZhiWebViewController *)[Utils getVCFromSB:@"ZiZhiWebViewController" storyBoardName:nil];
        webVC.navigationItemtitle = @"帮助";
        webVC.urlStr = [NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, self.settingModel.helppage];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Custom method
- (void)feedBack {
    if(![[ZiZhiUserInfoLocalHelperModel userInfoLocalHelper] isLogin]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请先登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        
        // Add the actions.
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"反馈" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *postAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *tf = alertController.textFields.firstObject;
        
        if ([Utils isBlankString:tf.text]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"请输入意见内容";
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        }else {
            [self requestFeedBack:tf.text];
        }

    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        //        textField.backgroundColor = [UIColor orangeColor];
        textField.placeholder = @"输入你的意见，我们将为你不断改变";
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:postAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)highOpinion:(NSString*)degree{
    
    if(![[ZiZhiUserInfoLocalHelperModel userInfoLocalHelper] isLogin]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请先登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        // Add the actions.
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你选择了%@星级",degree] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *postAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *tf = alertController.textFields.firstObject;
        if ([Utils isBlankString:tf.text]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"请输入意见内容";
            [hud hide:YES afterDelay:kMBProgressHUDTipsTime];
        }else {
            [self requestGoodPrize:tf.text pdegree:degree];
        }
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        //        textField.backgroundColor = [UIColor orangeColor];
        textField.placeholder = @"喜欢我吗，就给个好评吧";
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:postAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)goodPrize {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择星级" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *oneAction = [UIAlertAction actionWithTitle:@"★" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self highOpinion:@"1"];
    }];
    UIAlertAction *twoAction = [UIAlertAction actionWithTitle:@"★★" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self highOpinion:@"2"];
    }];
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"★★★" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self highOpinion:@"3"];
    }];
    UIAlertAction *fourAction = [UIAlertAction actionWithTitle:@"★★★★" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self highOpinion:@"4"];
    }];
    UIAlertAction *fiveAction = [UIAlertAction actionWithTitle:@"★★★★★" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self highOpinion:@"5"];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:oneAction];
    [alertController addAction:twoAction];
    [alertController addAction:thirdAction];
    [alertController addAction:fourAction];
    [alertController addAction:fiveAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
