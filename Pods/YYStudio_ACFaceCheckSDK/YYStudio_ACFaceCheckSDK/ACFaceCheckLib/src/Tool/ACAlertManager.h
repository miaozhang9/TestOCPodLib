//
//  PCAlertManager.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/5/24.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(void);

@interface ACAlertManager : NSObject

+ (instancetype)shareAlertManager;

- (void)showAlertMessageWithContent:(NSString *)content;

- (void)showAlertMessageWithOneContent:(NSString *)content actiontitle:(NSString *)title okeyAction:(ActionBlock)okeyAction;

- (void)showAlertMessageWithContent:(NSString *)content okeyAction:(ActionBlock)okeyAction cancelAction:(ActionBlock)cancelAction;

- (void)showAlertMessageWithTitle:(NSString *)title content:(NSString *)content okeyTitle:(NSString *)okeyTitle okeyAction:(ActionBlock)okeyAction cancelTitle:(NSString *)cancelTitle cancelAction:(ActionBlock)cancelAction;

@end
