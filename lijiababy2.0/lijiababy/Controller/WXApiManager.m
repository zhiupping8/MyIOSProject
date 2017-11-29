//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@interface WXApiManager ()

@property (strong, nonatomic) JSValue *payCallback;

@end

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        int code = 1; //未知错误
        switch (resp.errCode) {
            case WXSuccess:
                //成功
//                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                code = WXSuccess;
                break;
            case WXErrCodeCommon:
                //普通错误类型
                code = WXErrCodeCommon;
                break;
            case WXErrCodeUserCancel:
                //用户点击取消并返回
                code = WXErrCodeUserCancel;
                break;
            case WXErrCodeSentFail:
                //发送失败
                code = WXErrCodeSentFail;
                break;
            case WXErrCodeAuthDeny:
                //授权失败
                code = WXErrCodeAuthDeny;
                break;
            case WXErrCodeUnsupport:
                //微信不支持
                code = WXErrCodeUnsupport;
                break;
            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode, resp.errStr);
                break;
        }
        [self excuteScript:code];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
    }

}

- (void)onReq:(BaseReq *)req {

}

- (void)jumpToBizPay:(JSValue *)dict callback:(JSValue *)callback {
    self.payCallback = callback;
    BOOL isOk = [WXApi registerApp:@"wx82fffe95ca96310d"];
    if (isOk) {
        BOOL isInstalled = [WXApi isWXAppInstalled];
        if (isInstalled) {
            if (dict) {
                NSDictionary *tmpDict = [dict toDictionary];
                NSMutableString *retcode = [tmpDict objectForKey:@"retcode"];
                if (retcode.intValue == 0){
                    NSMutableString *stamp  = [tmpDict objectForKey:@"timestamp"];
                    
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [tmpDict objectForKey:@"partnerid"];
                    req.prepayId            = [tmpDict objectForKey:@"prepayid"];
                    req.nonceStr            = [tmpDict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [tmpDict objectForKey:@"package"];
                    req.sign                = [tmpDict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                    //日志输出
                }
            } else {
                NSLog(@"微信支付参数有误");
                [self excuteScript:-6];
            }
        } else {
            [self excuteScript:-7]; //用户未安装微信
        }
        
    } else {
        [self excuteScript:-8]; //应用注册失败
    }
    
    
}

- (void)excuteScript:(int)code {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.payCallback) {
            [self.payCallback callWithArguments:@[@(code)]];
        }
    });
}

@end
