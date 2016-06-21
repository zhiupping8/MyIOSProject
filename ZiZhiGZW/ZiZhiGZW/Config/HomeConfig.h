//
//  HomeConfig.h
//  ZiZhiGZW
//
//  Created by zyz on 11/30/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#ifndef HomeConfig_h
#define HomeConfig_h

#define kSegmentedControlHeight 30
#define kSelectionIndicatorHeight 4.0f
#define kTitleTextForegroundColor [UIColor blackColor]
#define kSelectedTitleTextForegroundColor RGBCOLOR(8, 171, 255)
#define kSelectionIndicatorColor RGBCOLOR(8, 171, 255)
#define kAnnouncementLabelColor RGBCOLOR(255, 241, 0)
#define kSegmentedControlBackgroundColor [UIColor clearColor]
#define kSegmentedScrollViewHeight (kScreenHeight - kSegmentedControlHeight - kNavigationBarHeight)


//notification identifier
#define kNotificationApply @"ApplyTicketNotificationIdentifier"
#define kNotificationProgram @"ProgramNotificationIdentifier"

#define kLoginNotification @"kLoginNotification"
#define kSignUpRefreshNotification @"kSignUpRefreshNotification"
#define kMyVipRefreshNotification @"kMyVipRefreshNotification"
#define kMyTicketRefreshNotification @"kMyTicketRefreshNotification"
#define kGoToPayNotification @"kGoToPayNotification"

//local archive
#define kADModelArchive @"ad_model_archive"

#endif /* HomeConfig_h */
