//
//  LJInputQuantityViewController.m
//  lijiababy
//
//  Created by YongZhi on 29/10/2017.
//  Copyright © 2017 Upping8. All rights reserved.
//

#import "LJInputQuantityViewController.h"

@interface LJInputQuantityViewController ()
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIView *quantityView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@end

@implementation LJInputQuantityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInputView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupInputView {
    self.goodsName.text = self.goods[@"name"];
    self.showView.layer.cornerRadius = 5;
    self.cancelButton.layer.borderWidth = 0.5;
    self.cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.quantityView.layer.cornerRadius = 5;
    self.quantityView.layer.borderWidth = 1;
    self.quantityView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:94/255.0 blue:20/255.0 alpha:1.0].CGColor;
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.cancelButton.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = self.cancelButton.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.cancelButton.layer.mask = maskLayer1;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.doneButton.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = self.doneButton.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.doneButton.layer.mask = maskLayer2;
}
- (IBAction)doneButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kRestartDevice object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kInputDone object:self.quantityLabel.text];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}
- (IBAction)cancelButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kRestartDevice object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kInputCancel object:nil];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}


- (IBAction)increaseButtonPressed:(id)sender {
    NSInteger quantity = self.quantityLabel.text.integerValue;
    quantity++;
    self.quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)quantity];
}
- (IBAction)decreaseButtonPressed:(id)sender {
    NSInteger quantity = self.quantityLabel.text.integerValue;
    if (quantity > 1) {
        quantity--;
    }
    self.quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)quantity];
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
