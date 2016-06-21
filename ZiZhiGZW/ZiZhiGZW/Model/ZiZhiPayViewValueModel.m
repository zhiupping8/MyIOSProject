//
//  ZiZhiPayViewValueModel.m
//  ZiZhiGZW
//
//  Created by zyz on 12/18/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiPayViewValueModel.h"

@implementation ZiZhiPayViewValueModel

+ (instancetype)sharedModel {
    static ZiZhiPayViewValueModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[ZiZhiPayViewValueModel alloc] init];
    });
    return model;
}

@end
