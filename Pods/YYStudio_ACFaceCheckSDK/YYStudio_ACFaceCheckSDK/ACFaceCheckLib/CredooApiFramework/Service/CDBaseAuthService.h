//
//  AuthService.h
//  CredooApiFramework
//
//  Created by 徐佳良 on 16/11/3.
//  Copyright © 2016年 Credoo. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <PromiseKit/PromiseKit.h>

@interface CDBaseAuthService : NSObject

@property (nonatomic,assign)     BOOL isRelogin;

//+(CDBaseAuthService *)sharedInstance;


//保存最后登录的账户
+(void)saveLastLoginUserAccount:(NSString *)account;
//获取最后登录账户
+(NSString *)lastLoginUserAccount;

+(void)saveUserInfoJson:(NSString *)json;

/**
 *  获取本地缓存的用户信息
 */
+(NSString *)getUserInfoJson;

/**
 *  清空Token，并发送重新登录的Notification
 */
+(void)clearAuth;

/**
 *  清空本地用户信息，不发送Notification
 */
+(void)clearAuthWithoutLogin;

+(BOOL)checkLocalTokenValidWithToken:(NSString *)token;
@end
