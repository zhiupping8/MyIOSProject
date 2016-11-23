//
//  RootTabBarController.m
//  Coding
//
//  Created by YongZhi on 21/11/2016.
//  Copyright © 2016 eric. All rights reserved.
//

#import "RootTabBarController.h"
#import "BaseNavigationViewController.h"
#import "ProjectRootViewController.h"
#import "TaskRootViewController.h"
#import "TweetRootViewController.h"
#import "MessageRootViewController.h"
#import "MeRootViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RKSwipeBetweenViewControllers/RKSwipeBetweenViewControllers.h>


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
    ProjectRootViewController *projectRootViewController = [[ProjectRootViewController alloc] init];
    UINavigationController *navProjectController = [[BaseNavigationViewController alloc] initWithRootViewController:projectRootViewController];
    
    TaskRootViewController *taskRootViewController = [[TaskRootViewController alloc] init];
    UINavigationController *navTaskController = [[BaseNavigationViewController alloc] initWithRootViewController:taskRootViewController];
    
    RKSwipeBetweenViewControllers *navTweetController = [[RKSwipeBetweenViewControllers alloc] init];
    TweetRootViewController *tmpTweetRootViewController = [[TweetRootViewController alloc] init];
    [navTweetController.viewControllerArray addObjectsFromArray:@[tmpTweetRootViewController]];
    navTweetController.buttonText = @[@"冒泡广场", @"朋友圈", @"热门冒泡"];
    
    MessageRootViewController *messageRootViewController = [[MessageRootViewController alloc] init];
    UINavigationController *navMessageController = [[BaseNavigationViewController alloc] initWithRootViewController:messageRootViewController];
    
    MeRootViewController *meRootViewController = [[MeRootViewController alloc] init];
    UINavigationController *navMeController = [[BaseNavigationViewController alloc] initWithRootViewController:meRootViewController];
    
    [self setViewControllers:@[navProjectController, navTaskController, navTweetController, navMessageController, navMeController]];
}


#pragma mark - RDVTabBarControllerDelegate
/**
 * Asks the delegate whether the specified view controller should be made active.
 */
- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (tabBarController.selectedViewController != viewController) {
        return YES;
    }
    
    if (![viewController isKindOfClass:[UINavigationController class]]) {
        return YES;
    }
    UINavigationController *nav = (UINavigationController *)viewController;
    if (nav.topViewController != nav.viewControllers[0]) {
        return YES;
    }
    
    //    if ([nav isKindOfClass:[RKSwipeBetweenViewControllers class]]) {
    //        RKSwipeBetweenViewControllers *swipeVC = (RKSwipeBetweenViewControllers *)nav;
    //        if ([[swipeVC curViewController] isKindOfClass:[BaseViewController class]]) {
    //            BaseViewController *rootVC = (BaseViewController *)[swipeVC curViewController];
    //            [rootVC tabBarItemClicked];
    //        }
    //    }else{
    //        if ([nav.topViewController isKindOfClass:[BaseViewController class]]) {
    //            BaseViewController *rootVC = (BaseViewController *)nav.topViewController;
    //            [rootVC tabBarItemClicked];
    //        }
    //    }
    
    
    return YES;
}

/**
 * Tells the delegate that the user selected an item in the tab bar.
 */
- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}
@end
