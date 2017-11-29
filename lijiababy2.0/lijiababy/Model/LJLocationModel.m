//
//  LJLocationModel.m
//  lijiababy
//
//  Created by YongZhi on 30/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJLocationModel.h"

@implementation LJLocationModel

- (instancetype)initDictionary:(NSDictionary *)locationDic {
    if (self = [super init]) {
        if (!locationDic) {
            self.latitude = locationDic[@"latitude"];
            self.longitude = locationDic[@"longitude"];
        }
    }
    return self;
}

@end
