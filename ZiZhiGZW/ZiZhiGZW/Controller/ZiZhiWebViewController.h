//
//  ZiZhiWebViewController.h
//  ZiZhiGZW
//
//  Created by zyz on 12/11/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZiZhiWebViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) NSString *urlStr;
@property (strong, nonatomic) NSString *navigationItemtitle;
@end
