//
//  ZiZhiHomeViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 11/30/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiHomeViewController.h"





@interface ZiZhiHomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *segmentedScrollView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation ZiZhiHomeViewController

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
       [weakSelf.segmentedScrollView scrollRectToVisible:CGRectMake(kScreenWidth * index, 0, kScreenWidth,kSegmentedScrollViewHeight) animated:YES];
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
    
    
    ZiZhiApplyTicketViewController *applyTicketViewController = (ZiZhiApplyTicketViewController *)[Utils getVCFromSB:@"ZiZhiApplyTicketViewController" storyBoardName:nil];
    self.applyTickteViewController = applyTicketViewController;
    applyTicketViewController.view.frame = CGRectMake(0, 0, self.segmentedScrollView.frame.size.width, self.segmentedScrollView.frame.size.height);
    [self.segmentedScrollView addSubview:applyTicketViewController.view];
    [self addChildViewController:applyTicketViewController];
    
    ZiZhiProgramSignUpViewController *programSignUpViewController = (ZiZhiProgramSignUpViewController *)[Utils getVCFromSB:@"ZiZhiProgramSignUpViewController" storyBoardName:nil];
    self.programSignUpViewController = programSignUpViewController;
//    programSignUpViewController.view.backgroundColor = [UIColor clearColor];
    programSignUpViewController.view.frame = CGRectMake(self.segmentedScrollView.frame.size.width, 0, self.segmentedScrollView.frame.size.width, self.segmentedScrollView.frame.size.height);
    [self.segmentedScrollView addSubview:programSignUpViewController.view];
    [self addChildViewController:programSignUpViewController];
}

- (void)initUI {
    [self initSegmentedControl];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 36, 36)];
    imageView.image = [UIImage imageNamed:@"64-1"];
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 90, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.text = @"中视观众";
    [view addSubview:titleLabel];
    self.navigationItem.titleView = view;
    
    CGRect rect = self.navigationController.navigationBar.bounds;
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, rect.size.height-3, rect.size.width, 3)];
    barImageView.image = [UIImage imageNamed:@"bar"];
    [self.navigationController.navigationBar addSubview:barImageView];
    
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoApplyTicket:) name:kNotificationApply object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoProgram:) name:kNotificationProgram object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationApply object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationProgram object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self addNotification];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeNotification];
}
#pragma mark - Notification method
- (void)gotoApplyTicket:(NSNotification *)notification {
    [self.segmentedControl setSelectedSegmentIndex:0 animated:YES];
}

- (void)gotoProgram:(NSNotification *)notification {
    [self.segmentedControl setSelectedSegmentIndex:1 animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
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
