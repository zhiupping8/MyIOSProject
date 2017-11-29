//
//  LJLocationModel.h
//  lijiababy
//
//  Created by YongZhi on 30/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJLocationModel : NSObject

@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *longitude;


- (instancetype)initDictionary:(NSDictionary *)locationDic;

@end
