//
//  ZiZhiTicketDetailModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiTicketDetailModel : NSObject
//{"tipxuzhicontent":"\"中式观众VIP通知：\r\n1. 须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1\r\n1. 须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1\r\n1. 须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1\r\n1. 须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1\r\n1. 须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1须知内容1",
//    "tipxuzhititle":"中式观众VIP通知",
//    "tipimgcontent":"imgcontent/setting/632141f9-ca5e-45ab-af7a-1ed336c67eb81449407715728.jsp",
//    "tiptitle":"申请综艺栏目通票"}
@property (strong, nonatomic)NSString *tipxuzhicontent;
@property (strong, nonatomic)NSString *tipxuzhititle;
@property (strong, nonatomic)NSString *tipimgcontent;
@property (strong, nonatomic)NSString *tiptitle;

@end
