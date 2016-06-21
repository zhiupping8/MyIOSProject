//
//  ZiZhiLocalHelper.m
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiLocalHelper.h"

@implementation ZiZhiLocalHelper

+ (BOOL)fileExistsWithFileName:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[Utils modelPathWithName:fileName]];
}

+ (id)unarchiveObjectWithFileName:(NSString *)filename {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Utils modelPathWithName:filename]];
}

+ (void)archiveRootObject:(id)rootObject toFileName:(NSString *)filename {
    [NSKeyedArchiver archiveRootObject:rootObject toFile:[Utils modelPathWithName:filename]];
}

+ (void)removeItemWithFileName:(NSString *)filename {
    [[NSFileManager defaultManager] removeItemAtPath:[Utils modelPathWithName:filename] error:nil];
}

@end
