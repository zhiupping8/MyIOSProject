//
//  ZiZhiCommodityDetailModel.h
//  ZiZhiGZW
//
//  Created by 张Yongzhi on 6/23/16.
//  Copyright © 2016 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiCommodityDetailModel : NSObject

//{"code":"0","message":"获取数据成功","content":{"goodid":2,"tipinfo":"第二个商品","detailDescribePath":"图文页面的地址"}}

@property (strong, nonatomic) NSString *goodid;
@property (strong, nonatomic) NSString *tipinfo;
@property (strong, nonatomic) NSString *detailDescribePath;

@end
