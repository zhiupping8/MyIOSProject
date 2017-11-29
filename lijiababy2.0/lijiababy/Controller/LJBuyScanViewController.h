//
//  LJBuyScanViewController.h
//  lijiababy
//
//  Created by YongZhi on 18/10/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LBXScanViewController.h"

#define kGoToCartNotification @"kGoToCartNotification"

@interface LJBuyScanViewController : LBXScanViewController

typedef void(^LJInputtBlock)(NSArray *goodsArray);
/**
 @brief  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;

#pragma mark --增加拉近/远视频界面
@property (nonatomic, assign) BOOL isVideoZoom;

#pragma mark - 底部几个功能：开启闪光灯、相册、我的二维码
//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) UIButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;
//我的二维码
//@property (nonatomic, strong) UIButton *btnMyQR;

@property (copy, nonatomic) LJInputtBlock inputBlock;

@end
