//
//  ZiZhiTicketApplyModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/10/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiTicketApplyModel : NSObject

@property (strong, nonatomic) NSString *orderid;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *ismylogistic;//true(中视观众的物流), false(第三方), null(暂无物流信息)：数据转换时可能会出错实在不行就用nsstirng
@property (strong, nonatomic) NSString *logisticno;
@property (strong, nonatomic) NSString *logistictype;
@property (strong, nonatomic) NSString *logisticphone;
@property (strong, nonatomic) NSString *ticketapplyid;


@end
