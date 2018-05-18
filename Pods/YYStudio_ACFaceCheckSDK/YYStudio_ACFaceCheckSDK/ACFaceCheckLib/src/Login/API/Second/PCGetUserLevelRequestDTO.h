//
//  PCGetUserLevelRequestDTO.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "CredooApiFramework.h"
#import "PCUserLevelDTO.h"

@interface PCGetUserLevelRequestDTO : CDBaseRequestDTOForAuth

- (void)generateParamWithPhone:(NSString *)phone vUid:(NSString *)vUid captchaCode:(NSString *)captchaCode;

@end
