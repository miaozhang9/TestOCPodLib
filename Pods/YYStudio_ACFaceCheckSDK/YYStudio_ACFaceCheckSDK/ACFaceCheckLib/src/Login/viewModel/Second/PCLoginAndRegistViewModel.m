//
//  PCLoginAndRegistViewModel.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCLoginAndRegistViewModel.h"
#import "PCUserLevelService.h"
#import "ACAppConstant.h"
#import "PCUserLevelDTO.h"
#import <YYModel/YYModel.h>

@interface PCLoginAndRegistViewModel()

@property (nonatomic, strong) PCUserLevelService *userLevelService;

@end

@implementation PCLoginAndRegistViewModel

-(void)initReactive{
    [super initReactive];
    self.smsType = @"1";
    self.imgType = @"1";
    self.title = @"注册／登录";
 
}

#pragma mark - private



- (void)checkUserLevelConditionsuccess:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed{
   
        self.phoneNumMsg = nil;
        self.verifyCodeMsg = nil;

        if (self.phoneNum.length != 11) {
            self.phoneNumMsg = @"手机号不正确";
            NSError *error = [NSError errorWithDomain:@"手机号不正确" code:-1 userInfo:nil];
            failed(error);
          
        } else if (![self isValidateMobile:self.phoneNum]) {
            self.phoneNumMsg = @"手机号不正确";
            NSError *error = [NSError errorWithDomain:@"手机号不正确" code:-1 userInfo:nil];
            failed(error);
          
        } else if (self.verifyCode == nil || self.verifyCode.length <= 0){
            self.verifyCodeMsg = @"请重新获取图形验证码";
            NSError *error = [NSError errorWithDomain:@"请重新获取图形验证码" code:-1 userInfo:nil];
            failed(error);
           
        } else if (self.imgCaptchaDTO.vUid == nil || self.imgCaptchaDTO.vUid.length <= 0){
            self.verifyCodeMsg = @"请重新获取图形验证码";
            NSError *error = [NSError errorWithDomain:@"请重新获取图形验证码" code:-1 userInfo:nil];
            failed(error);
           
        }
        else {
            success(@(YES));
        }
 
}

#pragma mark -  手机号码验证
- (BOOL) isValidateMobile:(NSString *)mobile
{
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"1[34578]([0-9]){9}"];
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark - request
// 获取用户级别
-(void)getUserLevelRequesSignalsuccess:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed{
    [self.userLevelService getUserLevelWithWithPhone:self.phoneNum vUid:self.imgCaptchaDTO.vUid captchaCode:self.verifyCode success:^(id data) {
          success(data);
    } failed:^(NSError *error) {
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
}

#pragma mark - setter and getter

- (PCUserLevelService *)userLevelService
{
    if (!_userLevelService) {
        self.userLevelService = [PCUserLevelService share];
    }
    return _userLevelService;
}


- (ACAvailableListDTO *)getSchedules {
    NSDictionary *dic = @{@"schedules": @[ @{@"appointDate": @"2017-08-19", @"slots": @[@{@"slot": @"2",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"},@{@"slot": @"3",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"},@{@"slot": @"4",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"8"},@{@"slot": @"5",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"},@{@"slot": @"6",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"}]},@{@"appointDate": @"2017-08-20", @"slots": @[@{@"slot": @"2",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"},@{@"slot": @"3",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"},@{@"slot": @"4",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"8"},@{@"slot": @"5",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"},@{@"slot": @"6",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"}]},@{@"appointDate": @"2017-08-21", @"slots": @[@{@"slot": @"2",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"},@{@"slot": @"3",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"},@{@"slot": @"4",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"8"},@{@"slot": @"5",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"},@{@"slot": @"6",@"startTime": @"525022016",@ "endTime": @"526022016",@"availableCount": @"4"}]}]};
    ACAvailableListDTO *dto = [ACAvailableListDTO yy_modelWithDictionary:dic];
    return dto;
}


@end
