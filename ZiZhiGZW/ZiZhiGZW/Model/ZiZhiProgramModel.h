//
//  ZiZhiProgramModel.h
//  ZiZhiGZW
//
//  Created by zyz on 12/10/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProgramUpdateRecords;

@interface ZiZhiProgramModel : NSObject

@property (strong, nonatomic) NSString *programid;
@property (strong, nonatomic) NSString *programname;
@property (strong, nonatomic) NSArray *records;//(ProgramUpdateRecords)
@property (strong, nonatomic) NSString *programPicPath;//节目图片
@property (strong, nonatomic) NSString *logoPicPath;//节目logo图片
@property (strong, nonatomic) NSString *state;//节目当前的状态
@property (strong, nonatomic) NSString *time;//节目时间
@property (strong, nonatomic) NSString *address;//录制地点
@property (strong, nonatomic) NSString *audienceRequest;//观众要求

@end
