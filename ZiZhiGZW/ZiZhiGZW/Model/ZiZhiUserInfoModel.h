//
//  ZiZhiUserInfoModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiUserInfoModel : NSObject
//{"address":null,
//    "audienceEndTime":null,
//    "audienceStartTime":null,
//    "bChannerId":null,
//    "bUserId":null,
//    "deviceType":null,
//    "id":2,
//"idCardNumber":"13043419900511525X",
//    "isAudienceRater":null,
//    "lastTicketApplyTime":1449901379493,
//    "name":null,
//"phone":"18500501605",
//    "spreadState":true}
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *idCardNumber;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *lastTicketApplyTime;
@property (strong, nonatomic) NSString *spreadState;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *bChannerId;
@property (strong, nonatomic) NSString *bUserId;
@property (strong, nonatomic) NSString *audienceEndTime;
@property (strong, nonatomic) NSString *audienceStartTime;
@property (strong, nonatomic) NSString *deviceType;
@property (strong, nonatomic) NSString *isAudienceRater;
@property (strong, nonatomic) NSString *name;
@end
