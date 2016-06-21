//
//  ZiZhiLocalHelper.h
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiZhiLocalHelper : NSObject
+ (BOOL)fileExistsWithFileName:(NSString *)fileName;

+ (id)unarchiveObjectWithFileName:(NSString *)filename;

+ (void)archiveRootObject:(id)rootObject toFileName:(NSString *)filename;

+ (void)removeItemWithFileName:(NSString *)filename;
@end
