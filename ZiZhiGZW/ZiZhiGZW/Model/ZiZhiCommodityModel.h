//
//  ZiZhiCommodityModel.h
//  ZiZhiGZW
//
//  Created by 张Yongzhi on 6/22/16.
//  Copyright © 2016 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiCommodityModel : NSObject
//{"picpath":"http://p2.so.qhimg.com/sdr/512_768_/t019932b3ef135f06d2.jpg","goodid":1,"tippriceinfo":120,"tipinfo":"第一个商品","tiptip":"第一个商品的描述信息"}

@property (strong, nonatomic) NSString *picpath;
@property (strong, nonatomic) NSString *goodid;
@property (strong, nonatomic) NSString *tippriceinfo;
@property (strong, nonatomic) NSString *tipinfo;
@property (strong, nonatomic) NSString *tiptip;

@end
