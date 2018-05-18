//
//  PCGetSmsCoderRequestDTO.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "CredooApiFramework.h"
#import "PCVcodeDTO.h"

// 获取短信验证码
@interface PCGetSmsCoderRequestDTO : CDBaseRequestDTOForAuth

- (void)generateParamWithType:(NSString *)type vUid:(NSString *)vUid captchaCode:(NSString *)captchaCode phone:(NSString *)phone;

@end
