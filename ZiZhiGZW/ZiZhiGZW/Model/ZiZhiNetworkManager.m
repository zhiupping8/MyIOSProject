//
//  ZiZhiNetworkManager.m
//  ZiZhiLaku2
//
//  Created by zyz on 11/29/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiNetworkManager.h"

static ZiZhiNetworkManager *_sharedManager;

@implementation ZiZhiNetworkManager

//single instance
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ZiZhiNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:K_NETWORK_BASE]];
        _sharedManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedManager.requestSerializer.timeoutInterval = 10.0f; //network timeout
        _sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html", nil];
        _sharedManager.responseSerializer.stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        [_sharedManager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    });
    return _sharedManager;
}

//override GET
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSMutableDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    //set parameters deafult key-objects
    
    return [super GET:URLString parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject){
        CCLog(@"****%@ GET request success:%@", URLString, responseObject);
        success( operation, responseObject );
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
        CCLog(@"****%@ GET request failure:%@", URLString , error);
        failure( operation, error );
    }];
}

//override POST
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSMutableDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    //set parameters deafult key-objects
    
    return [super POST:URLString parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject){
        CCLog(@"****%@ POST request success:%@", URLString, responseObject);
        success( operation, responseObject );
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
        CCLog(@"****%@ POST request failure:%@", URLString, error);
        failure( operation, error );
    }];
}

- (void)get:(NSString *)URLString parameters:(NSMutableDictionary *)parameters success:(ZiZhiResponseSuccessDictionaryBlock)successBlock failure:(ZiZhiResponseErrorBlock)errorBlock{
//    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[Utils getCurrentVC].view animated:YES];
    [self GET:URLString parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject){
//        if([responseObject[@"status"] integerValue]==200){
//            [hud hide:YES afterDelay:0.0f];
//            
//        }else{
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"数据获取失败";
//            [hud hide:YES afterDelay:2.0f];
//        }
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"网络连接失败";
//        [hud hide:YES afterDelay:2.0f];
        errorBlock( error.code, K_INTERNET_ERROR);
    }];
}

- (void)post:(NSString *)URLString parameters:(NSMutableDictionary *)parameters success:(ZiZhiResponseSuccessDictionaryBlock)successBlock failure:(ZiZhiResponseErrorBlock)errorBlock{
    
//    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[Utils getCurrentVC].view animated:YES];
    
    [self POST:URLString parameters:parameters success:^(NSURLSessionDataTask * operation, id responseObject) {
//        if([responseObject[@"status"] integerValue]==200){
//            [hud hide:YES afterDelay:0.0f];
//            
//        }else{
//            hud.mode = MBProgressHUDModeText;
//            if([URLString isEqualToString:k_url_check]){
//                hud.labelText = @"账号或者密码错误";
//            }else if([URLString isEqualToString:k_url_indent]){
//                hud.labelText = @"没有数据";
//            }else if([URLString isEqualToString:k_url_getcomment]){
//                hud.labelText = @"没有评论";
//            }else if([URLString isEqualToString:k_url_addcart]){
//                hud.labelText = @"已添加到购物车";
//            }else{
//                hud.labelText = @"数据获取失败";
//            }
//            [hud hide:YES afterDelay:2.0f];
//        }
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * operation, NSError * error) {
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"网络连接失败";
//        [hud hide:YES afterDelay:2.0f];
        errorBlock(error.code, K_INTERNET_ERROR);
    }];
}

@end
