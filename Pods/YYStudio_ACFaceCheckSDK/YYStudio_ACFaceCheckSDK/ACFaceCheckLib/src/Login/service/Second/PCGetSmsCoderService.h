//
//  PCGetSmsCoderService.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseService.h"

@interface PCGetSmsCoderService : ACBaseService

- (void)getSmsCoderWithType:(NSString *)type vUid:(NSString *)vUid captchaCode:(NSString *)captchaCode phone:(NSString *)phone success:(void (^)(id data))success failed:(void(^)(NSError *error))failed;

@end
