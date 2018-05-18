//
//  PCGetSmsCoderRequestDTO.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCGetSmsCoderRequestDTO.h"

#import <YYModel/YYModel.h>

@implementation PCGetSmsCoderRequestDTO

-(instancetype)init{
    if (self = [super init]) {
        self.methodName = @"/qjj_app/anyloan/nologin/sms/otpCoder";
        self.httpMethod = HttpMethodPost;
    }
    return self;
}

- (void)generateParamWithType:(NSString *)type vUid:(NSString *)vUid captchaCode:(NSString *)captchaCode phone:(NSString *)phone {
    [self generateParamDic:@{@"type":type, @"vUid":vUid, @"captchaCode":captchaCode, @"phone":phone}];
}

-(id)getResponseByData:(NSDictionary *)dataDic error:(NSError *)error{
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        PCVcodeDTO *dto = [PCVcodeDTO yy_modelWithDictionary:dataDic];;
        return dto;
    }
    return nil;
}

@end
