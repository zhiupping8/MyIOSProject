//
//  LJMapController.h
//  lijiababy
//
//  Created by YongZhi on 30/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LJMapController : NSObject<UIActionSheetDelegate>

- (instancetype)initWithCallback:(JSValue *)callback;

- (void)showActionSheetWithView:(UIView *)view location:(JSValue *)location;
@end
