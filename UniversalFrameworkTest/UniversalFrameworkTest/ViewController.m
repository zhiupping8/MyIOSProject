//
//  ViewController.m
//  UniversalFrameworkTest
//
//  Created by YongZhi on 10/10/16.
//  Copyright © 2016 eric. All rights reserved.
//

#import "ViewController.h"
#import "MyViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *myButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    MyViewController *myViewController = [[MyViewController alloc] init];
//    [self.navigationController pushViewController:myViewController animated:YES];
    [self presentViewController:myViewController animated:YES completion:nil];
}
@end
