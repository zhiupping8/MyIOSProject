//
//  LJLongTimeTouchController.h
//  lijiababy
//
//  Created by YongZhi on 07/06/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kRecognizeRedirectNotification @"kRecognizeRedirectNotification"
@interface LJLongTimeTouchController : NSObject<UIActionSheetDelegate>

- (instancetype)initWithView:(UIView *)view;

- (void)longTimeTouch:(JSValue *)params shareCallback:(JSValue *)shareCallback recognizeCallback:(JSValue *)recognizeCallback;

@end
