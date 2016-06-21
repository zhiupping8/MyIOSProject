//
//  ZiZhiOrderModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/10/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiOrderModel : NSObject
@property (strong, nonatomic) NSString *orderraterid;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *logisticno;
@property (strong, nonatomic) NSString *ismylogistic;//true, false, null
@property (strong, nonatomic) NSString *logistictype;
@property (strong, nonatomic) NSString *logisticphone;
@end
