//
//  AuthService.m
//  CredooApiFramework
//
//  Created by 徐佳良 on 16/11/3.
//  Copyright © 2016年 Credoo. All rights reserved.
//

#import "CDBaseAuthService.h"
#import <TMCache/TMCache.h>
#import "CredooApiFrameworkConst.h"

@implementation CDBaseAuthService

//+(CDBaseAuthService *)sharedInstance{
//    static CDBaseAuthService *queue;
//    static dispatch_once_t once;
//    
//    dispatch_once(&once, ^ {
//        NSString *className = NSStringFromClass([self class]);
//        queue = [[NSClassFromString(className) alloc] init];
//    });
//    
//    return queue;
//}

//保存最后登录的账户
+(void)saveLastLoginUserAccount:(NSString *)account{
    //加密保存 使用IDFV 加密
//    [@"test" aes_encrypt:@"test"];
//    [[NSUserDefaults standardUserDefaults] setObject:json forKey:kLastLoginUserInfoKey];
}
//获取最后登录账户
+(NSString *)lastLoginUserAccount{
    return @"";
}

+(void)saveUserInfoJson:(NSString *)json{
    [[NSUserDefaults standardUserDefaults] setObject:json forKey:kCacheUserInfoKey];
}

/**
 *  获取本地缓存的用户信息
 */
+(NSString *)getUserInfoJson{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCacheUserInfoKey];;
}


/**
 *  清空Token，并发送重新登录的Notification
 */
+(void)clearAuth{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCacheUserInfoKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRelogin object:nil];
}

/**
 *  清空本地用户信息，不发送Notification
 */
+(void)clearAuthWithoutLogin{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCacheUserInfoKey];
}

+(BOOL)checkLocalTokenValidWithToken:(NSString *)token{
    //本地判断Token是否过期
   
    if (token != nil) {
            NSString *timestamp = token;
            if([[NSDate date] timeIntervalSince1970]> [self numberWithString:timestamp].longValue /1000){
                //登录Token失效，重新登录
                return false;
            }else{
                return true;
            }
        }else{
            return true;
        }
}

#pragma mark -- remove yykit,and copy the necessary code.

+ (NSNumber *)numberWithString:(NSString *)string {
    NSString *str = [[self stringByTrimWithString:string] lowercaseString];
    if (!str || !str.length) {
        return nil;
    }
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"true" :   @(YES),
                @"yes" :    @(YES),
                @"false" :  @(NO),
                @"no" :     @(NO),
                @"nil" :    [NSNull null],
                @"null" :   [NSNull null],
                @"<null>" : [NSNull null]};
    });
    id num = dic[str];
    if (num) {
        if (num == [NSNull null]) return nil;
        return num;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc)
            return [NSNumber numberWithLong:((long)num * sign)];
        else
            return nil;
    }
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

+ (NSString *)stringByTrimWithString:(NSString *)string {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [string stringByTrimmingCharactersInSet:set];
}

@end
