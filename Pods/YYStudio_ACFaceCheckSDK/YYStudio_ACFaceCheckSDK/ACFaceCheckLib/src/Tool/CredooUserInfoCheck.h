//
//  userInfoCheck.h
//  AiCredit
//
//  Created by apple on 15/3/9.
//  Copyright (c) 2015年 tyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 进入后台block typedef */
typedef void(^YTHandlerEnterBackgroundBlock)(NSNotification * _Nonnull note, NSTimeInterval stayBackgroundTime);

@interface CredooUserInfoCheck : NSObject
NS_ASSUME_NONNULL_BEGIN
/** 处理进入后台并计算留在后台时间间隔类 */
@property(nonatomic,strong,nullable) NSString *timeInterval;
+(nullable CredooUserInfoCheck *)sharedInstance;
/** 添加观察者并处理后台 */
+ (void)addObserverUsingBlock:(nullable YTHandlerEnterBackgroundBlock)block;
/** 移除后台观察者 */
+ (void)removeNotificationObserver:(nullable id)observer;

+(BOOL)isValidateEmail:(NSString *)email;

+(BOOL) isValidateMobile:(NSString *)mobile;

+(BOOL) isValidataUserName:(NSString *)username;

+(BOOL) isValidatePassword:(NSString *)password;
+(BOOL) isValidatePasswordWith:(NSString *)password min:(NSInteger)min max:(NSInteger)max;

+(BOOL) checkIdentityCardNo:(NSString*)cardNo;

+(BOOL) isValidVerifyCode:(NSString *)code;

+(BOOL) isValidatePaymentPwd:(NSString *)paymentPwd;

+(BOOL) isValidIDCard:(NSString *)cardNo;
NS_ASSUME_NONNULL_END
@end
