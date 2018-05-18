//
//  PCGetUserLevelService.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCUserLevelService.h"
#import "PCGetUserLevelRequestDTO.h"
#import "NSString+Addtion.h"
#import <TMCache/TMCache.h>
#import "NSString+Addtion.h"
#import "ACAppConstant.h"
#import "SystemConfigure.h"
@interface PCUserLevelService ()


@end

@implementation PCUserLevelService

+ (PCUserLevelService *)share
{
    static PCUserLevelService *instance = nil;
    static dispatch_once_t globaldata;
    dispatch_once(&globaldata, ^{
        instance = [[PCUserLevelService alloc] init];
        
    });
    return instance;
}


- (void)getUserLevelWithWithPhone:(NSString *)phoneNum vUid:(NSString *)vUid captchaCode:(NSString *)captchaCode success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        PCGetUserLevelRequestDTO *dto = [[PCGetUserLevelRequestDTO alloc]init];
        [dto generateParamWithPhone:phoneNum vUid:vUid captchaCode:captchaCode];
        CDHttpReqestForAuth *request = [[CDHttpReqestForAuth alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(PCUserLevelDTO *responseObj) {
            success(responseObj);
        } failed:^(NSError *error) {
            failed(error);
        }];
        
//    }];
}

- (void)updateUserLevel:(NSString *)userLevel {
    self.userAuthDTO.userLevel = userLevel;
}

- (BOOL)checkUserLevelWithType:(PCUserLevelType)type {
    NSArray *arr = [NSString charArrayFromString:self.userAuthDTO.userLevel];
    NSString *str = arr[type];
    return [str boolValue];
}

- (NSString *)accessToken {
    
    NSString *token = @"";
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:[SystemConfigure shareSystemConfigure].get_kHttpURL]];
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:@"accessToken"]) {
            token = [NSString stringWithFormat:@"%@",cookie.value];
            [[TMCache sharedCache] setObject:token forKey:kLoginTokenKey];
            break;
        }
    }
    return token;
}

- (NSString *)lastPhoneNum {
   NSString *str = [[TMCache sharedCache] objectForKey:kLastLoginUserNameKey];
    if (str == nil) {
        return @"";
    } else {
        return str;
    }
}

- (NSString *)phoneNum {
    if (self.userAuthDTO == nil) {
        return @"";
    } else if (self.userAuthDTO.phone == nil) {
        return @"";
    } else {
        return self.userAuthDTO.phone.pc_stringByURLDecode;
    }
}

- (void)setUserAuthDTO:(PCUserAuthDTO *)userAuthDTO {
    userAuthDTO.name = userAuthDTO.name.pc_stringByURLDecode;
    _userAuthDTO = userAuthDTO;
}


@end
