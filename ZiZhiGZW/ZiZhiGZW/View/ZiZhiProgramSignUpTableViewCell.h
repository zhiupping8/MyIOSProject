//
//  ZiZhiProgramSignUpTableViewCell.h
//  ZiZhiGZW
//
//  Created by zyz on 12/8/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZiZhiProgramSignUpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireLabel;

@end
