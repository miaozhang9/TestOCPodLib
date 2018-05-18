//
//  PCGetUserLevelService.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseService.h"
#import "PCUserAuthDTO.h"

typedef enum : NSUInteger {
    PCUserLevelType_OTP = 0,
    PCUserLevelType_PWD,
    PCUserLevelType_IDCARD,
    PCUserLevelType_IDCARDAUTH,
    PCUserLevelType_PAY
} PCUserLevelType;


@interface PCUserLevelService : ACBaseService

@property (nonatomic, strong) PCUserAuthDTO *userAuthDTO;

@property (nonatomic, copy) NSString *lastPhoneNum;

@property (nonatomic, copy) NSString *phoneNum;

// 从cookie中获取到的accessToken
@property (nonatomic, copy) NSString *accessToken;

+ (PCUserLevelService *)share;

- (void)getUserLevelWithWithPhone:(NSString *)phoneNum vUid:(NSString *)vUid captchaCode:(NSString *)captchaCode success:(void (^)(id data))success failed:(void(^)(NSError *error))failed ;

// 更新当前用户等级
- (void)updateUserLevel:(NSString *)userLevel;

// 判断当前用户是否是type类型
- (BOOL)checkUserLevelWithType:(PCUserLevelType)type;

@end



