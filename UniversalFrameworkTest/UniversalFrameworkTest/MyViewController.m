//
//  MyViewController.m
//  UniversalFrameworkTest
//
//  Created by YongZhi on 10/10/16.
//  Copyright © 2016 eric. All rights reserved.
//

#import "MyViewController.h"
#import <Masonry/Masonry.h>

@interface MyViewController ()

@end

@implementation MyViewController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    CGRect rect = [[[UIApplication sharedApplication] keyWindow] bounds];
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)addTestView {
    CGRect rect = self.view.bounds;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, rect.size.width - 20, rect.size.height - 20)];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).width.insets(padding);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTestView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
