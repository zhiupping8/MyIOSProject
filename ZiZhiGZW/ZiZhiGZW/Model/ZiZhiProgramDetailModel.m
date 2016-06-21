//
//  ZiZhiProgramDetailModel.m
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiProgramDetailModel.h"

@implementation ZiZhiRecordModel

@end

@implementation ZiZhiProgramDetailModel
- (void)keyValuesDidFinishConvertingToObject {
    self.records = [ZiZhiRecordModel objectArrayWithKeyValuesArray:self.records];
}
@end
