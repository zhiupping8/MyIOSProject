//
//  FMHelper.h
//  DataStorage
//
//  Created by YongZhi on 18/11/2016.
//  Copyright © 2016 eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface FMHelper : NSObject

+ (instancetype)sharedInstance;
- (void)reloadDB;
- (BOOL)DBAvailable;

#pragma mark - Originality
- (void)inDatabase:(void(^)(FMDatabase *db))block;
- (void)inDatabase:(void(^)(FMDatabase *db))block crashOnErrors:(BOOL)crashOnErrors;

- (void)inTransaction:(void (^)(FMDatabase *db))block;
- (void)inTransaction:(void (^)(FMDatabase *db))block crashOnErrors:(BOOL)crashOnErrors;

#pragma mark - Encompass

- (NSMutableArray *)executeQueryDAL:(NSString *)sql;
- (NSInteger)executeUpdateDAL:(NSString *)sql;

@end
