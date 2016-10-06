//
//  ViewController.m
//  MyUtils
//
//  Created by YongZhi on 10/6/16.
//  Copyright © 2016 eric. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Operations.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *tmp = @" 1 2 3 4 5 \n";
    NSLog(@"%@", [tmp trim]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
