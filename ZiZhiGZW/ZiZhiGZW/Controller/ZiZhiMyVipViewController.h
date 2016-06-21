//
//  ZiZhiMyVipViewController.h
//  ZiZhiGZW
//
//  Created by zyz on 12/9/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZiZhiMyVipViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (void)logout;
- (void)requestList;
@end
