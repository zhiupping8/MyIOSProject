//
//  ZiZhiChooseTimeViewController.h
//  ZiZhiGZW
//
//  Created by zyz on 12/13/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnIndexBlock)(NSInteger selectedIndex,NSString *timeText);
@interface ZiZhiChooseTimeViewController : UIViewController
@property (nonatomic, copy) ReturnIndexBlock returnInfoBlock;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSArray *records;
@property (assign, nonatomic) NSString *timeText;
@end
