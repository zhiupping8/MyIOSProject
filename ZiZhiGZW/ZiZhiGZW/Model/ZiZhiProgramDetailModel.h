//
//  ZiZhiProgramDetailModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZiZhiRecordModel : NSObject
//{"contentimgpath":"imgcontent/program/8024da59-af38-4a26-b757-746d641bce511449305355202.jsp",
//"programupdateid":3,
//"contactname":"刘杰",
//"recordaddress":"12312",
//"contactphone":"13630817623",
//"audiencerequest":"关宏要求",
//"lng":114.583063,
//"recordtime":"2015.12.17-04:49",
//"lat":38.056413}
@property (strong, nonatomic) NSString *contentimgpath;
@property (strong, nonatomic) NSString *programupdateid;
@property (strong, nonatomic) NSString *contactname;
@property (strong, nonatomic) NSString *recordaddress;
@property (strong, nonatomic) NSString *contactphone;
@property (strong, nonatomic) NSString *audiencerequest;
@property (strong, nonatomic) NSString *recordtime;
@property (assign, nonatomic) double lng;
@property (assign, nonatomic) double lat;

@end

@interface ZiZhiProgramDetailModel : NSObject
//{"logoPicPath":"/images/program/logo/707b2aa1-c703-4729-8f1d-4af2b51d13691449385390039.png",
//    "programid":1,
//    "programname":"第二个节目",
//    "records":[{"contentimgpath":"imgcontent/program/8024da59-af38-4a26-b757-746d641bce511449305355202.jsp","programupdateid":3,"contactname":"刘杰","recordaddress":"12312","contactphone":"13630817623","audiencerequest":"关宏要求","lng":114.583063,"recordtime":"2015.12.17-04:49","lat":38.056413},
//    {"contentimgpath":"imgcontent/program/d863b286-f80a-463f-8c13-40b7693cd6381449306479699.jsp","programupdateid":4,"contactname":"123","recordaddress":"石家庄","contactphone":"13630817623","audiencerequest":"啊打飞机啊的事发生的风口浪尖阿斯顿；放假啊速度；分厘卡似的分厘卡机是对方；伐啦技术的疯狂拉升的飞机啊是；速度；搭街坊a；塑料袋放进askdl；放假啊是；的发链接阿斯蒂芬；垃圾堆sf；了","lng":123,"recordtime":"2015.12.19-05:07","lat":121}]
//}

@property (strong, nonatomic) NSString *logoPicPath;
@property (strong, nonatomic) NSString *programid;
@property (strong, nonatomic) NSString *programname;
@property (strong, nonatomic) NSArray *records;
@end
