//
//  ZiZhiWeiXinPayModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/14/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiWeiXinPayModel : NSObject
//appId = wxc389fb420030507c;
//empty = 0;
//nonceStr = 8a7cf65139a9fbb34f03b046d8dc597c;
//packageValue = "Sign=WXPay";
//partnerId = 1259499501;
//prepayId = wx20151214170940f96b1cdef60732942207;
//sign = 75F983042A4F59FABA6C3B88758C07BE;
//timeStamp = 1450084188;

@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *empty;
@property (strong, nonatomic) NSString *nonceStr;
@property (strong, nonatomic) NSString *packageValue;
@property (strong, nonatomic) NSString *partnerId;
@property (strong, nonatomic) NSString *prepayId;
@property (strong, nonatomic) NSString *sign;
@property (strong, nonatomic) NSString *timeStamp;
@end
