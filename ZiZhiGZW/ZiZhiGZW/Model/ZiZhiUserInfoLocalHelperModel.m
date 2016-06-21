//
//  ZiZhiUserInfoLocalHelperModel.m
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiUserInfoLocalHelperModel.h"

@implementation ZiZhiUserInfoLocalHelperModel
+ (instancetype)userInfoLocalHelper {
    static ZiZhiUserInfoLocalHelperModel * model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[ZiZhiUserInfoLocalHelperModel alloc]init];
        if ([ZiZhiLocalHelper fileExistsWithFileName:kUserInfoArchive]) {
            model.userInfoModel = [ZiZhiLocalHelper unarchiveObjectWithFileName:kUserInfoArchive];
        }
    });
    return model;
}

- (BOOL)isLogin {
    return [ZiZhiLocalHelper fileExistsWithFileName:kUserInfoArchive];
}

- (void)login:(ZiZhiUserInfoModel *)userInfo {
//    self.userInfoModel.id = userInfo.id;
//    self.userInfoModel.idCardNumber = userInfo.idCardNumber;
//    self.userInfoModel.phone = userInfo.phone;
//    self.userInfoModel.lastTicketApplyTime = userInfo.lastTicketApplyTime;
//    self.userInfoModel.spreadState = userInfo.spreadState;
//    self.userInfoModel.address = userInfo.address;
//    self.userInfoModel.bChannerId = userInfo.bChannerId;
//    self.userInfoModel.bUserId = userInfo.bUserId;
//    self.userInfoModel.audienceEndTime = userInfo.audienceEndTime;
//    self.userInfoModel.audienceStartTime = userInfo.audienceStartTime;
//    self.userInfoModel.deviceType = userInfo.deviceType;
//    self.userInfoModel.isAudienceRater = userInfo.isAudienceRater;
//    self.userInfoModel.name = userInfo.name;
    self.userInfoModel = userInfo;
    [ZiZhiLocalHelper archiveRootObject:userInfo toFileName:kUserInfoArchive];
}
- (void)logout {
    self.userInfoModel = nil;
    [ZiZhiLocalHelper removeItemWithFileName:kUserInfoArchive];
}

@end
