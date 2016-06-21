//
//  ZiZhiADViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/10/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiADViewController.h"
#import "ZiZhiADModel.h"
#import "ZiZhiRootViewController.h"
#import "ZiZhiAdDetailViewController.h"

@interface ZiZhiADViewController () {
    NSTimer *timer;
    NSInteger end;
}
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;


@end

@implementation ZiZhiADViewController

- (void)initUI {
    self.timeButton.layer.cornerRadius = 5;
    self.timeButton.layer.masksToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, self.adModel.picpath]] placeholderImage:[UIImage imageNamed:@"首页.jpg"]];
    [self addTouchEventToImageView];
    
    // Do any additional setup after loading the view.
    end = 5;
    [self startTimer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:kAdDetailMiss object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAdDetailMiss object:nil];
    [timer invalidate];
    timer = nil;
}

- (void)countDown {
    [self.timeButton setTitle:[NSString stringWithFormat:@"%ld点击跳过", (long)end] forState:UIControlStateNormal];
    if (end < 0) {
        [self stopTimer];
        [self touchTimeButton:self.timeButton];
    }else {
        end--;
    }
}

- (void)touchImageView:(UIGestureRecognizer *)gesture {
    //go to detail view
    CCLog(@"detail:%@", self.adModel.detailpath);
    if (self.adModel.detailpath != nil) {
        ZiZhiAdDetailViewController *webVC = (ZiZhiAdDetailViewController *)[Utils getVCFromSB:@"ZiZhiAdDetailViewController" storyBoardName:nil];
        if ([self.adModel.detailpath hasPrefix:@"http"]) {
            webVC.urlStr = self.adModel.detailpath;
        }else {
            webVC.urlStr = [NSString stringWithFormat:@"%@%@%@", K_NETWORK_BASE, K_BASE_FIELD, self.adModel.detailpath];
        }
        [self presentViewController:webVC animated:YES completion:^{
    
        }];
        [self stopTimer];
    }
}

- (void)addTouchEventToImageView {
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageView:)];
    self.adImageView.userInteractionEnabled = YES;
    [self.adImageView addGestureRecognizer:gesture];
}



#pragma mark - Target Action
- (IBAction)touchTimeButton:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)startTimer {
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)stopTimer {
    [timer invalidate];
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
