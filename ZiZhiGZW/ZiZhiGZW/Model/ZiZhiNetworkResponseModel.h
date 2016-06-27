//
//  ZiZhiNetworkResponseModel.h
//  ZiZhiLaku2
//
//  Created by zyz on 11/29/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Code)
{
    CodeSuccess = 0,//成功
    CodeSuccess2 = 1, //只有商品订单提交成功才有可能有这个状态码(1表示已经存在的用户，0表示新用户)
    CodeNoData = 101 ,
    CodeError = 201 ,//
};
@interface ZiZhiNetworkResponseModel : NSObject
@property (assign, nonatomic) Code httpCode;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *content;

@end
