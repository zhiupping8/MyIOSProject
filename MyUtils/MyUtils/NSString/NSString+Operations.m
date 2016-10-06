//
//  NSString+Operations.m
//  MyUtils
//
//  Created by YongZhi on 10/6/16.
//  Copyright © 2016 eric. All rights reserved.
//

#import "NSString+Operations.h"

@implementation NSString (Operations)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
