//
//  LJLongTimeTouchController.m
//  lijiababy
//
//  Created by YongZhi on 07/06/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJLongTimeTouchController.h"
#import "LJShareController.h"
#import "ZXingWrapper.h"
#import "StyleDIY.h"
#import "LBXScanViewController.h"

#import <MBProgressHUD.h>

@interface LJLongTimeTouchController ()
@property (weak, nonatomic)UIView *targetView;
@property (weak, nonatomic)UIActionSheet *actionSheet;

@property (strong, nonatomic)NSArray *targets;
@property (strong, nonatomic)JSValue *params;
@property (strong, nonatomic)JSValue *shareCallback;
@property (strong, nonatomic)JSValue *recognizeCallback;
@end


@implementation LJLongTimeTouchController

- (instancetype)initWithView:(UIView *)view {
    if (self = [super init]) {
        self.targetView = view;
    }
    return self;
}

- (NSArray *)targets {
    if (!_targets) {
        _targets = @[@"发送朋友", @"保存图片", @"识别图中二维码"];
    }
    return _targets;
}

- (void)longTimeTouch:(JSValue *)params shareCallback:(JSValue *)shareCallback recognizeCallback:(JSValue *)recognizeCallback {
    self.params = params;
    self.shareCallback = shareCallback;
    self.recognizeCallback = recognizeCallback;
    __weak __typeof(self) weakSelf = self;
    [self downLoadImage:^(UIImage *image) {
        if (image) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
            weakSelf.actionSheet = actionSheet;
            //    actionSheet.delegate = self;
            __block NSString *resultString = nil;
            [ZXingWrapper recognizeImage:image block:^(ZXBarcodeFormat barcodeFormat, NSString *str) {
                LBXScanResult *result = [[LBXScanResult alloc]init];
                result.strScanned = str;
                result.imgScanned = image;
                result.strBarCodeType = [weakSelf convertZXBarcodeFormat:barcodeFormat];
                
                resultString = [weakSelf scanResultForWithArray:@[result]];
                for (int i=0; i<[weakSelf.targets count]; i++) {
                    if (nil == resultString && 2 == i) {
                        break;
                    }
                    [actionSheet addButtonWithTitle:weakSelf.targets[i]];
                }
                [actionSheet showInView:weakSelf.targetView];
            }];
            
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.targetView animated:YES];
            hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
            hud.contentColor = [UIColor whiteColor];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"图片加载失败";
            hud.userInteractionEnabled = YES;
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }];
}

#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self shareImage];
            break;
        case 2:
            [self saveImage];
            break;
        case 3:
            [self recognizeImage];
            break;
        default:
            break;
    }
}

- (void)downLoadImage:(void (^)(UIImage *image))block {
    NSDictionary *dict = [self.params toDictionary];
    __block UIImage *image = nil;
    //图片下载链接
    NSURL *imageDownloadURL = [NSURL URLWithString:[dict objectForKey:@"images"]];
    
    //将图片下载在异步线程进行
    //创建异步线程执行队列
    dispatch_queue_t asynchronousQueue = dispatch_queue_create("imageDownloadQueue1", NULL);
    //创建异步线程
    dispatch_async(asynchronousQueue, ^{
        //网络下载图片  NSData格式
        NSError *error;
        NSData *imageData = nil;
        if (imageDownloadURL) {
            imageData = [NSData dataWithContentsOfURL:imageDownloadURL options:NSDataReadingMappedIfSafe error:&error];
        }
        if (imageData) {
            image = [UIImage imageWithData:imageData];
        }
        //回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            block(image);
        });
    });
}

- (void)shareImage {
    LJShareController *shareController = [LJShareController new];
    [shareController share:self.params callback:self.shareCallback withView:self.targetView];
}

- (void)saveImage {
    __weak __typeof(self) weakSelf = self;
    [self downLoadImage:^(UIImage *image) {
        [weakSelf loadImageFinished:image];
    }];
}

- (void)recognizeImage {
    __weak __typeof(self) weakSelf = self;
    [self downLoadImage:^(UIImage *image) {
        if (image) {
            [ZXingWrapper recognizeImage:image block:^(ZXBarcodeFormat barcodeFormat, NSString *str) {
                LBXScanResult *result = [[LBXScanResult alloc]init];
                result.strScanned = str;
                result.imgScanned = image;
                result.strBarCodeType = [weakSelf convertZXBarcodeFormat:barcodeFormat];
                
                [weakSelf scanResultWithArray:@[result]];
            }];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.targetView animated:YES];
            hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
            hud.contentColor = [UIColor whiteColor];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"图片加载失败";
            hud.userInteractionEnabled = YES;
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }];
}

- (NSString*)convertZXBarcodeFormat:(ZXBarcodeFormat)barCodeFormat
{
    NSString *strAVMetadataObjectType = nil;
    
    switch (barCodeFormat) {
        case kBarcodeFormatQRCode:
            strAVMetadataObjectType = @"qrcode";
            //            strAVMetadataObjectType = AVMetadataObjectTypeQRCode;
            break;
        case kBarcodeFormatEan13:
            strAVMetadataObjectType = @"barcode";
            //            strAVMetadataObjectType = AVMetadataObjectTypeEAN13Code;
            break;
        case kBarcodeFormatEan8:
            strAVMetadataObjectType = @"barcode";
            //            strAVMetadataObjectType = AVMetadataObjectTypeEAN8Code;
            break;
        case kBarcodeFormatPDF417:
            strAVMetadataObjectType = @"barcode";
            //            strAVMetadataObjectType = AVMetadataObjectTypePDF417Code;
            break;
        case kBarcodeFormatAztec:
            strAVMetadataObjectType = @"barcode";
            //            strAVMetadataObjectType = AVMetadataObjectTypeAztecCode;
            break;
        case kBarcodeFormatCode39:
            strAVMetadataObjectType = @"barcode";
            //            strAVMetadataObjectType = AVMetadataObjectTypeCode39Code;
            break;
        case kBarcodeFormatCode93:
            strAVMetadataObjectType = @"barcode";
            //            strAVMetadataObjectType = AVMetadataObjectTypeCode93Code;
            break;
        case kBarcodeFormatCode128:
            strAVMetadataObjectType = @"barcode";
            //            strAVMetadataObjectType = AVMetadataObjectTypeCode128Code;
            break;
        case kBarcodeFormatDataMatrix:
            strAVMetadataObjectType = @"barcode";
            //            strAVMetadataObjectType = AVMetadataObjectTypeDataMatrixCode;
            break;
        case kBarcodeFormatITF:
            strAVMetadataObjectType = @"barcode";
            //            strAVMetadataObjectType = AVMetadataObjectTypeITF14Code;
            break;
        case kBarcodeFormatRSS14:
            strAVMetadataObjectType = @"barcode";
            break;
        case kBarcodeFormatRSSExpanded:
            strAVMetadataObjectType = @"barcode";
            break;
        case kBarcodeFormatUPCA:
            strAVMetadataObjectType = @"barcode";
            break;
        case kBarcodeFormatUPCE:
            strAVMetadataObjectType = @"barcode";
            //            strAVMetadataObjectType = AVMetadataObjectTypeUPCECode;
            break;
        default:
            strAVMetadataObjectType = @"barcode";
            break;
    }
    
    
    return strAVMetadataObjectType;
}

- (NSString *)scanResultForWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        return nil;
    }
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        NSLog(@"scanResult:%@",result.strScanned);
        NSLog(@"scan type:%@", result.strBarCodeType);
    }
    LBXScanResult *scanResult = array[0];
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    if (scanResult.strScanned) {
        [resultDict setObject:scanResult.strScanned forKey:@"result"];
        return scanResult.strScanned;
    }
    return nil;
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        return;
    }
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        NSLog(@"scanResult:%@",result.strScanned);
        NSLog(@"scan type:%@", result.strBarCodeType);
    }
    LBXScanResult *scanResult = array[0];
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    if (scanResult.strScanned) {
        [resultDict setObject:scanResult.strScanned forKey:@"result"];
    }
    if (scanResult.strBarCodeType) {
        [resultDict setObject:scanResult.strBarCodeType forKey:@"type"];
    }
//    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * strResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.recognizeCallback) {
            if (resultDict) {
                [self.recognizeCallback callWithArguments:@[resultDict]];
            } else {
                NSDictionary *tmpDict = [NSDictionary new];
                [self.recognizeCallback callWithArguments:@[tmpDict]];
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRecognizeRedirectNotification object:scanResult.strScanned];
        }
    });
    
}

//save image
- (void)loadImageFinished:(UIImage *)image
{
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.targetView animated:YES];
        hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        hud.contentColor = [UIColor whiteColor];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"图片加载失败";
        hud.userInteractionEnabled = YES;
        [hud hideAnimated:YES afterDelay:1.5];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *text = @"图片保存成功";
    if (error) {
        NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
        text = @"图片保存失败";
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.targetView animated:YES];
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    hud.contentColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.userInteractionEnabled = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}


@end
