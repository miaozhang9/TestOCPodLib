//
//  PCGetCaptchaService.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseService.h"

@interface PCGetCaptchaService : ACBaseService

// 图形验证码 type:1：获取用户级别；2：身份验证（身份证+姓名验证）；3：身份验证（银行卡鉴权）；4：交易密码登录；5：设置登录密码
- (void)getImgCaptchaWithType:(NSString *)type success:(void (^)(id data))success failed:(void(^)(NSError *error))failed ;

@end
