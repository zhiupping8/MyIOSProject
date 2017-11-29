//
//  NSObject+JSCreateContext.m
//  lijiababy
//
//  Created by YongZhi on 07/05/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "NSObject+JSCreateContext.h"

@implementation NSObject (JSCreateContext)

- (void)webView:(id)unuse didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id)frame {
    [ctx setExceptionHandler:^(JSContext *ctx, JSValue *expectValue) {
        NSLog(@"JSContext ExpectValue: %@", expectValue);
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:LJDidCreateContextNotification object:ctx];
}

@end
