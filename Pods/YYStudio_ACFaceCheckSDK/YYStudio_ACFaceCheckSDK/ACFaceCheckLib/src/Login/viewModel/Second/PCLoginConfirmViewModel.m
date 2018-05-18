//
//  PCLoginConfirmViewModel.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCLoginConfirmViewModel.h"
#import "PCPasswordLoginService.h"

@interface PCLoginConfirmViewModel ()

@property (nonatomic, strong) PCPasswordLoginService *pwdLoginService;

@end

@implementation PCLoginConfirmViewModel

-(void)initReactive{
    self.title = @"注册／登录";
  
}

#pragma mark - request
// 密码登录
-(void)requestPasswordLoginSignalsuccess:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed {
    [self.pwdLoginService requestPasswordLoginWithPhone:self.phone password:self.password success:^(id data) {
         success(data);
    } failed:^(NSError *error) {
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
    
}

#pragma mark - private



- (void)checkPasswordLoginConditionsuccess:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed  {
  
        self.passwordMsg = nil;
        if (self.password.length < 6 || self.password.length > 20){
            self.passwordMsg = @"您输入密码错误";
            NSError *error = [NSError errorWithDomain:@"您输入密码错误" code:-1 userInfo:nil];
            success(error);
        } else {
            success(@(YES));
        }
   
}

#pragma mark - setter and getter

- (PCPasswordLoginService *)pwdLoginService {
    if (!_pwdLoginService) {
        self.pwdLoginService = [[PCPasswordLoginService alloc] init];
    }
    return _pwdLoginService;
}

@end
