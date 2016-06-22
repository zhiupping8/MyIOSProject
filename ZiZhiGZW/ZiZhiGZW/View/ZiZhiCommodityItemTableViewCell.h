//
//  ZiZhiCommodityItemTableViewCell.h
//  ZiZhiGZW
//
//  Created by 张Yongzhi on 6/22/16.
//  Copyright © 2016 zizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZiZhiCommodityItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commodityPic;
@property (weak, nonatomic) IBOutlet UILabel *commodityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityInfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *commodityPriceButton;
@end
