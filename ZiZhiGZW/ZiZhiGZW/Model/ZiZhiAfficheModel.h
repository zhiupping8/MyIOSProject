//
//  ZiZhiAfficheModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/14/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiAfficheModel : NSObject
//{"advType":2,
//    "endTime":1450833774000,
//    "id":8,
//"notContent":"这个一个公告,,",
//    "picture":"/images/advpic/d6de43c4-c9c4-44b8-9c33-38b0c66399801449148979890.png",
//    "time":1449148979961,
//    "type":2,
//    "url":"http://www.baidu.com"}

@property (strong, nonatomic) NSString *advType;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *notContent;
@property (strong, nonatomic) NSString *picture;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *url;

@end
