//
//  ZiZhiUserCenterViewController.h
//  ZiZhiGZW
//
//  Created by zyz on 12/9/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "ZiZhiMyTicketViewController.h"
#import "ZiZhiMyVipViewController.h"
#import "ZiZhiMySignUpViewController.h"
@interface ZiZhiUserCenterViewController : UIViewController
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (strong, nonatomic) ZiZhiMySignUpViewController *mySignUpViewController;
@property (strong, nonatomic) ZiZhiMyTicketViewController *myTicketViewController;
@property (strong, nonatomic) ZiZhiMyVipViewController *myVipViewController;
@end
