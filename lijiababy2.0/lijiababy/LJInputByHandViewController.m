//
//  LJInputByHandViewController.m
//  lijiababy
//
//  Created by YongZhi on 29/10/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJInputByHandViewController.h"

@interface LJInputByHandViewController ()
@property (weak, nonatomic) IBOutlet UITextField *barcodeTextField;

@end

@implementation LJInputByHandViewController

- (void)initNavigationBar {
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.exclusiveTouch = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.title = @"手动输入";
    
    [self initInputByScanItem];
}

- (void)backAction:(id)sender {
    
    //    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO]; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.barcodeTextField becomeFirstResponder];
    
    [self initNavigationBar];
    [self initAccessoryView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)inputByScan:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initInputByScanItem {
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"切换扫码" style:UIBarButtonItemStylePlain target:self action:@selector(inputByScan:)];
    rightBarItem.tintColor = [UIColor colorWithRed:233/255.0 green:94/255.0 blue:20/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)initAccessoryView {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    bar.tintColor = [UIColor colorWithRed:233/255.0 green:94/255.0 blue:20/255.0 alpha:1.0];
    
    toolbar.items = @[space, bar];
    self.barcodeTextField.inputAccessoryView = toolbar;
}

- (void)textFieldDone {
    if (self.barcodeTextField.text.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kInputReturn object:self.barcodeTextField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
