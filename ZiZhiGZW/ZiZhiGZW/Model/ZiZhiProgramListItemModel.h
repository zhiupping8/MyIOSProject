//
//  ZiZhiProgramListItemModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiProgramListItemModel : NSObject
//{"audienceRequest":"第一个节目的观众要求",
//    "time":"2015年3月-2017年6月",
//    "programPicPath":"/images/program/program/57c79e6c-bc9e-442a-96aa-9434a5c21d4c1449385390052.png",
//    "address":"河北石家庄",
//    "state":"报名中",
//    "logoPicPath":"/images/program/logo/707b2aa1-c703-4729-8f1d-4af2b51d13691449385390039.png",
//    "programid":"1"}
@property (strong, nonatomic) NSString *audienceRequest;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *programPicPath;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *logoPicPath;
@property (strong, nonatomic) NSString *programid;

@end
