//
//  ZiZhiUserInfoLocalHelperModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZiZhiUserInfoModel.h"

@interface ZiZhiUserInfoLocalHelperModel : NSObject
@property (strong, nonatomic) ZiZhiUserInfoModel *userInfoModel;
@property (strong, nonatomic) NSString *bChannerId;
@property (strong, nonatomic) NSString *bUserId;


+ (instancetype)userInfoLocalHelper;

- (BOOL)isLogin;

- (void)login:(ZiZhiUserInfoModel *)userInfo;
- (void)logout;

@end
