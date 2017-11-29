//
//  LJShareController.m
//  lijiababy
//
//  Created by YongZhi on 04/05/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJShareController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <MBProgressHUD.h>

@interface LJShareController ()

@property (strong, nonatomic) JSValue *shareCallback;

@end

@implementation LJShareController

- (void)share:(NSDictionary *)params shareCallback:(JSValue *)shareCallback withView:(UIView *)view {
    self.shareCallback = shareCallback;
    if (!params) {
        [self excuteScript:-3];
        return;
    }
    NSString *text = [params objectForKey:@"text"];
    NSString *title = [params objectForKey:@"title"];
    NSString *urlString = [params objectForKey:@"url"];
    id images = [params objectForKey:@"images"];
    if (!images) {
        images = @[[UIImage imageNamed:@"icon.png"]];
    }

    //1、创建分享参数
//    NSArray* imageArray = [images componentsSeparatedByString:@","];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:images
                                        url:[NSURL URLWithString:urlString]
                                      title:title
                                       type:SSDKContentTypeAuto];
    if (text) {
        text = [NSString stringWithFormat:@"%@%@", text, urlString];
    } else {
        if (urlString) {
            text = urlString;
        } else {
            text = @"";
        }
    }
    [shareParams SSDKSetupSinaWeiboShareParamsByText:text title:title image:images url:[NSURL URLWithString:urlString] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    //有的平台要客户端分享需要加此方法，例如微博
    [shareParams SSDKEnableUseClientShare];
    
    NSArray *itmes = nil;
    if (urlString) {
        itmes = @[@(SSDKPlatformSubTypeWechatSession),
                  @(SSDKPlatformSubTypeWechatTimeline),
                  @(SSDKPlatformSubTypeQQFriend),
                  @(SSDKPlatformSubTypeQZone),
                  @(SSDKPlatformTypeSinaWeibo),
                  @(SSDKPlatformTypeCopy)];
    } else {
        itmes = @[@(SSDKPlatformSubTypeWechatSession),
                  @(SSDKPlatformSubTypeWechatTimeline),
                  @(SSDKPlatformSubTypeQQFriend),
                  @(SSDKPlatformSubTypeQZone),
                  @(SSDKPlatformTypeSinaWeibo)];
    }
  
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:itmes
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   int code = 0;
                   switch (state) {
                       case SSDKResponseStateSuccess: {
                           code = 0;
                           [self excuteScript:code];
                           break;
                       }
                       case SSDKResponseStateCancel: {
                           code = -1;
                           [self excuteScript:code];
                           break;
                       }
                       case SSDKResponseStateFail: {
                           code = -2;
                           [self excuteScript:code];
                           break;
                       }
                       default:
                           break;
                   }
                   if (0 == code && SSDKPlatformTypeCopy == platformType) {
                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
                       hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
                       hud.contentColor = [UIColor whiteColor];
                       hud.mode = MBProgressHUDModeText;
                       hud.label.text = @"复制成功";
                       hud.userInteractionEnabled = YES;
                       [hud hideAnimated:YES afterDelay:2.0];
                   }
                   
               }
     ];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeCopy)];
}

- (void)share:(JSValue *)params callback:(JSValue *)callback withView:(UIView *)view {
    NSDictionary *tmpParams = [params toDictionary];
    [self share:tmpParams shareCallback:callback withView:view];
}

- (void)shareLJWithView:(UIView *)view {
    NSString *text = @"分享内容";
    NSString *title = @"丽家宝贝";
    NSString *urlString = @"http://m.lijiababy.com.cn/";
    NSArray *images = @[[UIImage imageNamed:@"icon.png"]];

    NSDictionary *params = @{
                             @"text":text,
                             @"title":title,
                             @"url":urlString,
                             @"images":images
                             };
    [self share:params shareCallback:self.shareCallback withView:view];
}

- (void)excuteScript:(int)code {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.shareCallback) {
            [self.shareCallback callWithArguments:@[@(code)]];
        }
    });
}

//- (UIView *)topView {
//    UIViewController *topViewController = [self topViewController];
//    for (id view in [[topViewController view] subviews]) {
//        if ([view isKindOfClass:[UIWebView class]]) {
//            return view;
//        }
//    }
//    return [topViewController view];
//}
//
//- (UIViewController *)topViewController {
//    UIViewController *resultVC;
//    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
//    while (resultVC.presentedViewController) {
//        resultVC = [self _topViewController:resultVC.presentedViewController];
//    }
//    return resultVC;
//}
//
//- (UIViewController *)_topViewController:(UIViewController *)vc {
//    if ([vc isKindOfClass:[UINavigationController class]]) {
//        return [self _topViewController:[(UINavigationController *)vc topViewController]];
//    } else if ([vc isKindOfClass:[UITabBarController class]]) {
//        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
//    } else {
//        return vc;
//    }
//    return nil;
//}

@end
