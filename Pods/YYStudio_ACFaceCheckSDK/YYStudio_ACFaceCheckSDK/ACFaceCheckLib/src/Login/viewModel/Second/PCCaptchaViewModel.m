//
//  PCCaptchaViewModel.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCCaptchaViewModel.h"
#import "PCGetCaptchaService.h"
#import "PCGetSmsCoderService.h"
#import "CredooUserInfoCheck.h"
#import "CredooApiFramework.h"
@interface PCCaptchaViewModel ()

@property (nonatomic, strong) PCGetCaptchaService *getCaptchaService;
@property (nonatomic, strong) PCGetSmsCoderService *getSmsService;

@end

@implementation PCCaptchaViewModel

- (void)initReactive{
    self.title = @"注册／登录";
    self.isSendSMS = YES;
}

#pragma mark - private
//
//// 子类重写，实现不同的条件判断
- (void)checkSMSCodeConditionsuccess:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
   
        self.phoneNumMsg = nil;
        self.verifyCodeMsg = nil;
    
        if (![CredooUserInfoCheck isValidateMobile:self.phoneNum]) {
            self.phoneNumMsg = @"手机号不正确";
            NSError *error =  [NSError errorWithDomain:@"手机号不正确" code:-1 userInfo:nil];
            failed(error);
           
        } else if (self.verifyCode == nil || self.verifyCode.length <= 0){
            self.verifyCodeMsg = @"请重新获取图形验证码";
            NSError *error =  [NSError errorWithDomain:@"请重新获取图形验证码" code:-1 userInfo:nil];
            failed(error);
           
        } else {
            success(@(YES));
        }

}

// 子类可重写实现图形验证码、短信验证码失败之后清空记录
- (void)clearCaptchaRecord {
    [self clearImageCaptcha];
}

// 清楚图形验证码信息
- (void)clearImageCaptcha {
    self.imgCaptchaDTO = nil;
    self.validVUid = NO;
}

// 短信验证码成功回掉
- (void)sendSMSCodeSuccess {

}

// 短信验证码成功失败
- (void)sendSMSCodeFail {
    
}

#pragma mark - request


//// 获取图形验证码
-(void)getImgCaptchaSignalsuccess:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
     __weak typeof(self)weakSelf = self;
   
    [self.getCaptchaService getImgCaptchaWithType:self.imgType success:^(id data) {
        weakSelf.imgCaptchaDTO = data;
        success(data);
    } failed:^(NSError *error) {
        [weakSelf clearCaptchaRecord];
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
}

// 发送短信验证码
-(void)sendCodeRequesSignalsuccess:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
    
     __weak typeof(self)weakSelf = self;
    [self.getSmsService getSmsCoderWithType:self.smsType vUid:self.imgCaptchaDTO.vUid captchaCode:self.verifyCode phone:self.phoneNum success:^(id data) {
        [weakSelf sendSMSCodeSuccess];
        success(data);
    } failed:^(NSError *error) {
        
        [weakSelf sendSMSCodeSuccess];
        [weakSelf clearCaptchaRecord];
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
}

#pragma mark - setter and getter

- (PCGetCaptchaService *)getCaptchaService {
    if (!_getCaptchaService) {
        self.getCaptchaService = [[PCGetCaptchaService alloc] init];
    }
    return _getCaptchaService;
}

- (PCGetSmsCoderService *)getSmsService {
    if (!_getSmsService) {
        self.getSmsService = [[PCGetSmsCoderService alloc] init];
    }
    return _getSmsService;
}

@end

