//
//  ViewController.h
//  lijiababy
//
//  Created by YongZhi on 20/04/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJWebViewController.h"


@interface ViewController : LJWebViewController

#pragma mark - 3D Touch Notification Deal

- (void)shareLJOf3D;

- (void)scanOf3D;

- (void)gotoMyHome;

- (void)gotoMyCart;

- (void)gotoNearby;


@end

