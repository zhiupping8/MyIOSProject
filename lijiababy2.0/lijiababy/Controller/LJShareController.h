//
//  LJShareController.h
//  lijiababy
//
//  Created by YongZhi on 04/05/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LJShareController : NSObject

- (void)shareLJWithView:(UIView *)view;
- (void)share:(JSValue *)params callback:(JSValue *)callback withView:(UIView *)view;
- (void)share:(NSDictionary *)params shareCallback:(JSValue *)shareCallback withView:(UIView *)view;
@end
