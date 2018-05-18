//
//  PCImgCaptchaRequestDTO.h
//  PersonalCenter
//
//  Created by Miaoz on 2017/5/17.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "CredooApiFramework.h"

// 获取图形验证码
@interface PCGetCaptchaRequestDTO : CDBaseRequestDTOForAuth

- (void)generateParamWithType:(NSString *)type;

@end
