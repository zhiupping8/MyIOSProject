//
//  ZiZhiHomeViewController.h
//  ZiZhiGZW
//
//  Created by zyz on 11/30/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMSegmentedControl/HMSegmentedControl.h>
//#import "ZiZhiApplyTicketViewController.h"
#import "ZiZhiEnterpriseTicketViewController.h"
#import "ZiZhiProgramSignUpViewController.h"
@interface ZiZhiHomeViewController : UIViewController
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) ZiZhiEnterpriseTicketViewController *enterpriseTicketViewController;
//@property (strong, nonatomic) ZiZhiApplyTicketViewController *applyTickteViewController;
@property (strong, nonatomic) ZiZhiProgramSignUpViewController *programSignUpViewController;
@end
