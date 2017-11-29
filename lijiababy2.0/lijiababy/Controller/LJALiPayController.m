//
//  LJALiPayController.m
//  lijiababy
//
//  Created by YongZhi on 27/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJALiPayController.h"
#import "LJALiPayOrder.h"
#import <UIKit/UIKit.h>

#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface LJALiPayController ()

@property (strong, nonatomic) JSValue *payCallback;

@end

@implementation LJALiPayController

static LJALiPayController* _singleton = nil;

+(instancetype) sharedInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _singleton = [[super allocWithZone:NULL] init] ;
    }) ;
    return _singleton ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [LJALiPayController sharedInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [LJALiPayController sharedInstance] ;
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPay:(JSValue *)orderString callback:(JSValue *)callback {
    self.payCallback = callback;
    NSString *appScheme = @"com.lijiaBabay.app";
    __weak __typeof__(self) weakself = self;
    [[AlipaySDK defaultService] payOrder:[orderString toString] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        [weakself dealWithResult:resultDic];
    }];
}

-(void)dealWithResult:(NSDictionary *)result {
//    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.payCallback) {
            if (result) {
                [self.payCallback callWithArguments:@[result]];
            } else {
                NSDictionary *tmpDictionary = [NSDictionary new];
                [self.payCallback callWithArguments:@[tmpDictionary]];
            }
        }
    });
}

@end
