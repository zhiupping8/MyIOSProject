//
//  ZiZhiNetworkManager.h
//  ZiZhiLaku2
//
//  Created by zyz on 11/29/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface ZiZhiNetworkManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

//shared get method
- (void)get:(NSString *)URLString parameters:(NSMutableDictionary *)parameters success:(ZiZhiResponseSuccessDictionaryBlock)successBlock failure:(ZiZhiResponseErrorBlock)errorBlock;

//shared post method
- (void)post:(NSString *)URLString parameters:(NSMutableDictionary *)parameters success:(ZiZhiResponseSuccessDictionaryBlock)successBlock failure:(ZiZhiResponseErrorBlock)errorBlock;

@end
