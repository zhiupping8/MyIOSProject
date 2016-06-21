//
//  ZiZhiMySignUpViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/9/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiMySignUpViewController.h"
#import "ZiZhiMySignUpTableViewCell.h"
#import "ZiZhiProgramEnrollModel.h"
#import <CoreLocation/CoreLocation.h>

@interface ZiZhiMySignUpViewController ()<CLLocationManagerDelegate>
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (assign, nonatomic) NSInteger row;
@end

@implementation ZiZhiMySignUpViewController

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
        [self requestListInfo];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestListInfo];
    }];
    
    if ([[ZiZhiUserInfoLocalHelperModel userInfoLocalHelper] isLogin]) {
        [self.tableView.header beginRefreshing];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyToRefresh) name:kSignUpRefreshNotification object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSignUpRefreshNotification object:nil];
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
 *  节目报名列表
 *
 *  @param idnumber   id
 *  @param page    页码
 */
//static NSString * const k_url_programenroll_listinfo = @"/cctv/client/program/programenroll/listinfo.do";

- (void)requestListInfo {
    ZiZhiUserInfoLocalHelperModel *helper = [ZiZhiUserInfoLocalHelperModel userInfoLocalHelper];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([helper isLogin]) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:helper.userInfoModel.idCardNumber forKey:@"idnumber"];
        [params setObject:@(self.page) forKey:@"page"];
        [[ZiZhiNetworkManager sharedManager] get:k_url_programenroll_listinfo parameters:params success:^(NSDictionary *dictionary) {
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
                [self.dataArray addObjectsFromArray:[ZiZhiProgramEnrollModel objectArrayWithKeyValuesArray:[dictionary objectForKey:@"content"]]];
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"ZiZhiMySignUpTableViewCell";
    ZiZhiMySignUpTableViewCell *cell = (ZiZhiMySignUpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell = [[ZiZhiMySignUpTableViewCell alloc] init];
        [tableView registerClass:[ZiZhiMySignUpTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    ZiZhiProgramEnrollModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"姓名:%@", model.names];
    cell.programNameLabel.text = [NSString stringWithFormat:@"报名栏目:%@", model.programname];
    cell.timeLabel.text = [NSString stringWithFormat:@"报名场次:%@", model.time];
    cell.locationLabel.text = [NSString stringWithFormat:@"录制地点:%@", model.recordaddress];
    cell.linkmanLabel.text = [NSString stringWithFormat:@"现场联系人:%@", model.contactname];
    
    cell.requireLabel.numberOfLines = 0;//表示label可以多行显示
    cell.requireLabel.lineBreakMode = UILineBreakModeCharacterWrap;//换行模式，与上面的计算保持一致。
    cell.requireLabel.frame = CGRectMake(cell.requireLabel.frame.origin.x, cell.requireLabel.frame.origin.y, cell.requireLabel.frame.size.width, 42);
    cell.requireLabel.text = [NSString stringWithFormat:@"观众要求:%@", model.audiencerequest];
    [cell.phoneButton setTitle:model.contactphone forState:UIControlStateNormal];
//    cell.explainTextView.text = @"";
    
    //add touch event
    cell.locateImageView.userInteractionEnabled = YES;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchLocateImageView:)];
    [cell.locateImageView addGestureRecognizer:gesture];
    cell.locateImageView.tag = 10000+indexPath.row;
    
    [cell.phoneButton addTarget:self action:@selector(touchPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Touch Event
- (void)touchLocateImageView:(UIGestureRecognizer *)gesture {
    CCLog(@"gesture:%@", gesture);
    self.row = gesture.view.tag - 10000;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    [self.locationManager startUpdatingLocation];
}

- (void)touchPhoneButton:(UIButton *)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",sender.titleLabel.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
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
    ZiZhiProgramEnrollModel *model = [self.dataArray objectAtIndex:self.row];
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
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
