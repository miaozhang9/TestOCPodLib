//
//  PCVerifyCodeDTO.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/5/16.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseDTO.h"

@interface PCImgCaptchaDTO : ACBaseDTO

@property (nonatomic,copy)NSString * vUid;
@property (nonatomic,copy)NSString * captchaBase;

@end
