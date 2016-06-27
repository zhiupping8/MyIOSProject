//
//  ZiZhiHomeApplyViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/8/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiHomeApplyViewController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "ZiZhiApplyTicketDetailViewController.h"
#import "ZiZhiProgramSignUpViewController.h"

@interface ZiZhiHomeApplyViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *segmentedScrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation ZiZhiHomeApplyViewController

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"申请赠票", @"栏目报名"];
    }
    return _titles;
}

- (void)initSegmentedControl {
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.titles];
    [self.segmentedControl setFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kSegmentedControlHeight)];
    self.segmentedControl.selectionIndicatorHeight = kSelectionIndicatorHeight;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName: kTitleTextForegroundColor};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: kSelectedTitleTextForegroundColor};
    self.segmentedControl.selectionIndicatorColor = kSelectionIndicatorColor;
//    self.segmentedControl.backgroundColor = kSegmentedControlBackgroundColor;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.shouldAnimateUserSelection = YES;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (1 == index) {
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationProgram object:nil];
        }else if(0 == index){
            [weakSelf.segmentedScrollView scrollRectToVisible:CGRectMake(kScreenWidth * index, 0, kScreenWidth,kSegmentedScrollViewHeight) animated:YES];
        }
    }];
    [self.view addSubview:self.segmentedControl];
    
    self.segmentedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + kSegmentedControlHeight, kScreenWidth, kSegmentedScrollViewHeight)];
    self.segmentedScrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.segmentedScrollView.pagingEnabled = YES;
    self.segmentedScrollView.showsHorizontalScrollIndicator = NO;
    self.segmentedScrollView.contentSize = CGSizeMake(kScreenWidth * self.titles.count, kSegmentedScrollViewHeight);
    self.segmentedScrollView.delegate = self;
    self.segmentedScrollView.bounces = NO;
    [self.segmentedScrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, kSegmentedScrollViewHeight) animated:NO];
    [self.view addSubview:self.segmentedScrollView];
    
    
    ZiZhiApplyTicketDetailViewController *applyTicketViewDetailController = (ZiZhiApplyTicketDetailViewController *)[Utils getVCFromSB:@"ZiZhiApplyTicketDetailViewController" storyBoardName:nil];
    applyTicketViewDetailController.view.frame = CGRectMake(0, 0, self.segmentedScrollView.frame.size.width, self.segmentedScrollView.frame.size.height);
    [self.segmentedScrollView addSubview:applyTicketViewDetailController.view];
    [self addChildViewController:applyTicketViewDetailController];
    
    ZiZhiProgramSignUpViewController *programSignUpViewController = (ZiZhiProgramSignUpViewController *)[Utils getVCFromSB:@"ZiZhiProgramSignUpViewController" storyBoardName:nil];
    programSignUpViewController.view.backgroundColor = [UIColor clearColor];
    programSignUpViewController.view.frame = CGRectMake(self.segmentedScrollView.frame.size.width, 0, self.segmentedScrollView.frame.size.width, self.segmentedScrollView.frame.size.height);
    [self.segmentedScrollView addSubview:programSignUpViewController.view];
    [self addChildViewController:programSignUpViewController];
}

- (void)initUI {
    [self initSegmentedControl];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cctv_log"]];
    imageView.frame = CGRectMake(0, 0, 120, 37);
    self.navigationItem.titleView = imageView;
    
    CGRect rect = self.navigationController.navigationBar.bounds;
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, rect.size.height-3, rect.size.width, 3)];
    barImageView.image = [UIImage imageNamed:@"bar"];
    [self.navigationController.navigationBar addSubview:barImageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    if (1 == page) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationProgram object:nil];
    }else {
        [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
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
