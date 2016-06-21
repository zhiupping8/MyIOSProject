//
//  ZiZhiVipDetailModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiVipDetailModel : NSObject
//{"tipxuzhicontent":"阿迪沙发水电费阿萨德爱迪生阿萨德阿萨德阿萨德阿萨德",
//    "vipprice":365,
//    "tipxuzhititle":"中式观众VIP须知",
//    "tipimgcontent":"imgcontent/setting/2bfbc136-d937-431f-95b1-4133735ced3a1449408106637.jsp",
//    "tiptitle":"中视观众VIP"}

@property (strong, nonatomic) NSString *tipxuzhicontent;
@property (strong, nonatomic) NSString *vipprice;
@property (strong, nonatomic) NSString *tipimgcontent;
@property (strong, nonatomic) NSString *tiptitle;
@property (strong, nonatomic) NSString *tipxuzhititle;

@end
