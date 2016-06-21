//
//  ZiZhiProgramEnrollModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/10/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiProgramEnrollModel : NSObject

@property (strong, nonatomic) NSString *programname;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *recordaddress;
@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lng;
@property (strong, nonatomic) NSString *contactname;
@property (strong, nonatomic) NSString *contactphone;
@property (strong, nonatomic) NSString *audiencerequest;
@property (strong, nonatomic) NSString *names;

@end
