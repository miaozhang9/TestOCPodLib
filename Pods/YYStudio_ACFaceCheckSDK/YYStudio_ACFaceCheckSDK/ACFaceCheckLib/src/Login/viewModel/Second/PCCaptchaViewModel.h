//
//  PCCaptchaViewModel.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseViewModel.h"
#import "PCImgCaptchaDTO.h"
#import "PCVcodeDTO.h"

@interface PCCaptchaViewModel : ACBaseViewModel

// 是否发送短信验证码
@property (nonatomic, assign) BOOL isSendSMS;

// 图形验证码类型
@property (nonatomic, copy) NSString *imgType;
// 短信验证码类型
@property (nonatomic, copy) NSString *smsType;

// 手机号
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, assign) BOOL validPhoneNum;
@property (nonatomic, copy) NSString *phoneNumMsg;
// 图形验证码
@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, assign) BOOL validVerifyCode;
@property (nonatomic, copy) NSString *verifyCodeMsg;

// 短信验证码
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, assign) BOOL validSmsCode;
@property (nonatomic, copy) NSString *smsCodeMsg;
// 图形验证码model
@property (nonatomic, strong) PCImgCaptchaDTO *imgCaptchaDTO;
@property (nonatomic, assign) BOOL validVUid;

// 短信验证码
//@property (nonatomic, strong) RACCommand *sendSMSCodeCommand;

// 获取图形验证码
-(void)getImgCaptchaSignalsuccess:(void (^)(id data))success failed:(void(^)(NSError *error))failed;
// 发送短信验证码
-(void)sendCodeRequesSignalsuccess:(void (^)(id data))success failed:(void(^)(NSError *error))failed;
////获取图形验证码
//-(RACSignal *)getImgCaptchaSignal;
//
////发送验证码
//-(RACSignal *)sendCodeRequesSignal;

// 清楚图形验证码信息
- (void)clearImageCaptcha;

@end
