//
//  UIApplication+UserNotificaitonHelper.h
//  QHLoanSDK
//
//  Created by 黄世光 on 2017/4/20.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
@interface UIApplication (UserNotificaitonHelper)

- (void)registerUserNotificationWithDelegate:(id <UNUserNotificationCenterDelegate>)delegate;

@end
