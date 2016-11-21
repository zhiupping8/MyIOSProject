//
//  FMHelper.m
//  DataStorage
//
//  Created by YongZhi on 18/11/2016.
//  Copyright © 2016 eric. All rights reserved.
//

#import "FMHelper.h"

@implementation FMHelper

+(instancetype)sharedInstance {
    static dispatch_once_t oncToken;
    __strong static id _sharedSingleton = nil;
    dispatch_once(&oncToken, ^{
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}

@end
