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
    CodeNoData = 101 ,
    CodeError = 201 ,//
};
@interface ZiZhiNetworkResponseModel : NSObject
@property (assign, nonatomic) Code httpCode;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *content;

@end
