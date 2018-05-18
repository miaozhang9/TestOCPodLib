//
//  GRAlertSheetViewController.h
//  GammRayFilters
//
//  Created by guopengwen on 2017/7/12.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseViewController.h"

typedef void(^PCAlertSheetAction)(id object);

@interface ACAlertSheetViewController : ACBaseViewController

@property (nonatomic, copy) NSString *cancleTitle;

@property (nonatomic, copy) NSString *okTitle;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancleAction:(PCAlertSheetAction)cancleAction okAction:(PCAlertSheetAction)okAction;

- (void)presentAlertSheetWithController:(UIViewController *)viewController;

- (void)dismissAlertSheet;

@end
