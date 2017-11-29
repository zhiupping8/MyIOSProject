//
//  LJBuyScanViewController.m
//  lijiababy
//
//  Created by YongZhi on 18/10/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJBuyScanViewController.h"
#import "LBXScanVideoZoomView.h"
#import "LBXAlertAction.h"
#import "ScanResultViewController.h"
#import "LBXScanNative.h"
#import "LJInputQuantityViewController.h"
#import "LJInputByHandViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface LJBuyScanViewController ()

@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) NSMutableDictionary *currentGoods;

@end

@implementation LJBuyScanViewController

- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray new];
    }
    return _goodsArray;
}

- (void)initNavigationBar {
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.exclusiveTouch = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.title = @"扫描条形码";
    
    [self initInputByHandItem];
}

- (void)backAction:(id)sender {
    if (self.goodsArray.count > 0) {
        self.inputBlock(self.goodsArray);
    }
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        self.zoomView = nil;
        self.zxingObj = nil;
        self.qRScanView = nil;
        self.scanImage = nil;
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationBar];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    //设置扫码后需要扫码图像
    self.isNeedScanImage = NO;
    self.style.centerUpOffset = self.view.frame.size.height/5;
    
    [self addRestartDeviceNotification];
    [self addInputDoneNotification];
    [self addInputCancelNotification];
    [self addInputReturnNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    [self initCardView];
    [self drawBottomItems];
    [self drawTitle];
//    [self.view bringSubviewToFront:_topTitle];
}

- (void)dealloc {
    [self removeRestartDeviceNotification];
    [self removeInputDoneNotification];
    [self removeInputCancelNotification];
    [self removeInputReturnNotification];
}

- (void)inputByHand:(id)sender {
    LJInputByHandViewController *inputByHandViewController = [[LJInputByHandViewController alloc] init];
    [self.navigationController pushViewController:inputByHandViewController animated:YES];
}
- (void)initInputByHandItem {
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"手动输入" style:UIBarButtonItemStylePlain target:self action:@selector(inputByHand:)];
    rightBarItem.tintColor = [UIColor colorWithRed:233/255.0 green:94/255.0 blue:20/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 180, 60);
        
        CGRect frame = self.view.frame;
        
        int XRetangleLeft = self.style.xScanRetangleOffset;
        
        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        
        if (self.style.whRatio != 1)
        {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;
            
            NSInteger hInt = (NSInteger)h;
            h  = hInt;
            
            sizeRetangle = CGSizeMake(w, h);
        }
        
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, YMaxRetangle + 30);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
//            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, YMaxRetangle + 30);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码/条码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}

- (void)cameraInitOver
{
    if (self.isVideoZoom) {
        [self zoomView];
    }
}

- (LBXScanVideoZoomView*)zoomView
{
    if (!_zoomView)
    {
        
        CGRect frame = self.view.frame;
        
        int XRetangleLeft = self.style.xScanRetangleOffset;
        
        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        
        if (self.style.whRatio != 1)
        {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;
            
            NSInteger hInt = (NSInteger)h;
            h  = hInt;
            
            sizeRetangle = CGSizeMake(w, h);
        }
        
        CGFloat videoMaxScale = [self.scanObj getVideoMaxScale];
        
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        
        CGFloat zoomw = sizeRetangle.width + 40;
        _zoomView = [[LBXScanVideoZoomView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18)];
        
        [_zoomView setMaximunValue:videoMaxScale/4];
        
        
        __weak __typeof(self) weakSelf = self;
        _zoomView.block= ^(float value)
        {
            [weakSelf.scanObj setVideoScale:value];
        };
        [self.view addSubview:_zoomView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
    }
    
    return _zoomView;
    
}

- (void)tap
{
    _zoomView.hidden = !_zoomView.hidden;
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-164,
                                                                   CGRectGetWidth(self.view.frame), 100)];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    //    self.btnPhoto = [[UIButton alloc]init];
    //    _btnPhoto.bounds = _btnFlash.bounds;
    //    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/3, CGRectGetHeight(_bottomItemsView.frame)/2);
    //    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    //    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    //    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    //    self.btnMyQR = [[UIButton alloc]init];
    //    _btnMyQR.bounds = _btnFlash.bounds;
    //    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    //    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
    //    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_down"] forState:UIControlStateHighlighted];
    //    [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    //    [_bottomItemsView addSubview:_btnPhoto];
    //    [_bottomItemsView addSubview:_btnMyQR];
    
}

- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str buttonsStatement:@[@"知道了"] chooseBlock:nil];
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
        NSLog(@"scan type:%@", result.strBarCodeType);
    }
    
    LBXScanResult *scanResult = array[0];
    if (!scanResult.strScanned) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    if (scanResult.strScanned) {
        [resultDict setObject:scanResult.strScanned forKey:@"result"];
    }
    if (scanResult.strBarCodeType) {
        [resultDict setObject:scanResult.strBarCodeType forKey:@"type"];
    }
    //    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:nil];
    //    NSString * strResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.scanImage = scanResult.imgScanned;
    
    
    
    //震动提醒
    // [LBXScanWrapper systemVibrate];
    //声音提醒
    //    [LBXScanWrapper systemSound];
    
    //    [self showNextVCWithScanResult:scanResult];
//    self.scanResultBlock(resultDict);
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    //show input quantity view
    if (scanResult.strScanned) {
        [self requestGoods:scanResult.strScanned from_scan_code:@"true"];
    }
}

- (void)showInputView {
    LJInputQuantityViewController *inputViewController = [[LJInputQuantityViewController alloc] init];
    inputViewController.goods = self.currentGoods;
    [self addChildViewController:inputViewController];
    [inputViewController.view setBounds:self.view.frame];
    inputViewController.view.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);
    [self.view addSubview:inputViewController.view];
//    [self.view bringSubviewToFront:inputViewController.view];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult buttonsStatement:@[@"知道了"] chooseBlock:^(NSInteger buttonIdx) {
        
        [weakSelf reStartDevice];
    }];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    ScanResultViewController *vc = [ScanResultViewController new];
    vc.imgScan = strResult.imgScanned;
    
    vc.strScan = strResult.strScanned;
    
    vc.strCodeType = strResult.strBarCodeType;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    if ([LBXScanPermissions cameraPemission])
        [self openLocalPhoto];
    else
    {
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
}

//开关闪光灯
- (void)openOrCloseFlash
{
    
    [super openOrCloseFlash];
    
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}

- (void)initCardView {
    CGRect rect = self.view.frame;
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.bounds = CGRectMake(0, 0, 100, 100);
    backgroundView.center = CGPointMake(CGRectGetWidth(rect)/2.0, CGRectGetHeight(rect) - 160);
    
    backgroundView.layer.cornerRadius = backgroundView.frame.size.height/2.0;
    backgroundView.backgroundColor = [UIColor colorWithRed:233/255.0 green:94/255.0 blue:20/255.0 alpha:1.0];
    UIButton *cardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cardButton setImage:[UIImage imageNamed:@"cart1.png"] forState:UIControlStateNormal];
    [cardButton setImage:[UIImage imageNamed:@"cart1.png"] forState:UIControlStateHighlighted];
    cardButton.tintColor = [UIColor whiteColor];
    cardButton.bounds = CGRectMake(0, 0, backgroundView.frame.size.width * 4/5.0, backgroundView.frame.size.height * 4 /5.0);
    cardButton.center = CGPointMake(backgroundView.frame.size.width/2.0, backgroundView.frame.size.height/2.0 - 10);
    [cardButton addTarget:self action:@selector(goToCard:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:cardButton];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.bounds = CGRectMake(0, 0, 80, 30);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"去商品清单";
    tipLabel.font = [UIFont boldSystemFontOfSize:14];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.center = CGPointMake(backgroundView.frame.size.width/2.0, backgroundView.frame.size.height - tipLabel.frame.size.height/2.0 - 10);
    [backgroundView addSubview:tipLabel];
    [self.view addSubview:backgroundView];
}

- (void)goToCard:(id)sender {
    if (self.goodsArray.count > 0) {
        self.inputBlock(self.goodsArray);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //go to cart
//    [[NSNotificationCenter defaultCenter] postNotificationName:kGoToCartNotification object:nil];
}

#pragma mark - Notification
- (void)addRestartDeviceNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reStartDevice) name:kRestartDevice object:nil];
}

- (void)removeRestartDeviceNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRestartDevice object:nil];
}

- (void)addInputDoneNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputDone:) name:kInputDone object:nil];
}

- (void)removeInputDoneNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInputDone object:nil];
}

- (void)addInputCancelNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputCancel) name:kInputCancel object:nil];
}

- (void)removeInputCancelNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInputCancel object:nil];
}

- (void)addInputReturnNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputReturn:) name:kInputReturn object:nil];
}

- (void)removeInputReturnNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInputReturn object:nil];
}

- (void)addGoods {
    for (NSDictionary *tmpDict in self.goodsArray) {
        if ([tmpDict[@"sku"] isEqualToString:self.currentGoods[@"sku"]]) {
            [self.goodsArray removeObject:tmpDict];
            break;
        }
    }
    [self.goodsArray addObject:self.currentGoods];
}

- (void)inputDone:(NSNotification *)notification {
    NSLog(@"input quantity:%@", notification.object);
    [self.currentGoods setObject:(NSString *)notification.object forKey:@"quantity"];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    [self.currentGoods setObject:timeLocal forKey:@"addTime"];
    [self addGoods];
}

- (void)inputCancel {
    //go to cart
    if (self.goodsArray.count > 0) {
        self.inputBlock(self.goodsArray);
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kGoToCartNotification object:nil];
}

- (void)inputReturn:(NSNotification *)notification {
    NSLog(@"input quantity:%@", notification.object);
    [self requestGoods:(NSString *)notification.object from_scan_code:@"false"];
}

#pragma mark - request

- (void)requestGoods:(NSString *)barcode from_scan_code:(NSString *)from_scan_code{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    hud.contentColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.label.text = @"";
    hud.userInteractionEnabled = NO;
    [self.view bringSubviewToFront:hud];
    AFHTTPSessionManager *sharedManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://m.ljmall.staging.dmright.com:8889/"]];
    sharedManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    sharedManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sharedManager.requestSerializer.timeoutInterval = 10.0f; //network timeout
    sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
//    sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html", nil];
    sharedManager.responseSerializer.stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
//    [sharedManager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:barcode forKey:@"barcode"];
    [dictionary setObject:from_scan_code forKey:@"from_scan_code"];
    [sharedManager GET:@"/api/self-checkout/item/search" parameters:dictionary success:^(NSURLSessionDataTask *operation, id responseObject){
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (responseDict[@"msg"] == [NSNull null]) {
            [hud hideAnimated:YES];
            self.currentGoods = [NSMutableDictionary dictionaryWithDictionary:responseDict[@"item"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showInputView];
            });
        } else {
            [hud hideAnimated:YES];
            MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud1.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
            hud1.contentColor = [UIColor whiteColor];
            hud1.mode = MBProgressHUDModeText;
            hud1.detailsLabel.text = responseDict[@"msg"];
            hud1.userInteractionEnabled = YES;
            [self.view bringSubviewToFront:hud1];
            [hud1 hideAnimated:YES afterDelay:1.5];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
        [hud hideAnimated:YES];
        MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud1.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        hud1.contentColor = [UIColor whiteColor];
        hud1.mode = MBProgressHUDModeText;
        hud1.label.text = @"商品请求失败";
        hud1.userInteractionEnabled = YES;
        [self.view bringSubviewToFront:hud1];
        [hud1 hideAnimated:YES afterDelay:1.5];
    }];
}


@end
