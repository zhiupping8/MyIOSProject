//
//  RootTabBarController.m
//  Coding
//
//  Created by YongZhi on 21/11/2016.
//  Copyright © 2016 eric. All rights reserved.
//

#import "RootTabBarController.h"

@implementation RootTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewControllers {
    
}


#pragma mark - RDVTabBarControllerDelegate
/**
 * Asks the delegate whether the specified view controller should be made active.
 */
- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

/**
 * Tells the delegate that the user selected an item in the tab bar.
 */
- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}
@end
