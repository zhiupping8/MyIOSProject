//
//  ZiZhiNetworkResponseModel.m
//  ZiZhiLaku2
//
//  Created by zyz on 11/29/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiNetworkResponseModel.h"

@implementation ZiZhiNetworkResponseModel

- (void)keyValuesDidFinishConvertingToObject {
    self.httpCode = [self.code integerValue];
}

@end
