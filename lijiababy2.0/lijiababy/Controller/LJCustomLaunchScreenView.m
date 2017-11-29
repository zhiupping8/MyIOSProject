//
//  LJCustomLaunchScreenView.m
//  lijiababy
//
//  Created by YongZhi on 16/10/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJCustomLaunchScreenView.h"

@implementation LJCustomLaunchScreenView

+ (void)showCustomLaunchScreenViewWithStoryboardName:(NSString *)storyboard {
    LJCustomLaunchScreenView *customLaunchScreenView = [[LJCustomLaunchScreenView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *story = nil;
    if (storyboard) {
        [UIStoryboard storyboardWithName:storyboard bundle:nil];
    }
    UIWindow *window = [customLaunchScreenView lastWindow];
    if (story) {
        UIViewController * vc = story.instantiateInitialViewController;
        window.rootViewController = vc;
        [vc.view addSubview:customLaunchScreenView];
    }else {
        [[[window rootViewController] view] addSubview:customLaunchScreenView];
    }
    [customLaunchScreenView addImage];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        [customLaunchScreenView removeFromSuperview];
    });
}

- (UIWindow *)lastWindow {
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
        
    }
    
    return [UIApplication sharedApplication].keyWindow;
    
}

- (void)addImage {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"launch" ofType:@"jpeg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    imageView.image = image;
    [self addSubview:imageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
