//
//  PCGetUserLevelRequestDTO.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCGetUserLevelRequestDTO.h"

#import <YYModel/YYModel.h>
@implementation PCGetUserLevelRequestDTO

- (instancetype)init{
    if (self = [super init]) {
        self.methodName = @"/qjj_app/anyloan/nologin/user/getUserLevel";
        self.httpMethod = HttpMethodGet;
    }
    return self;
}

- (void)generateParamWithPhone:(NSString *)phone vUid:(NSString *)vUid captchaCode:(NSString *)captchaCode{
    [self generateParamDic:@{@"vUid":vUid, @"captchaCode":captchaCode, @"phone":phone}];
}

- (id)getResponseByData:(NSDictionary *)dataDic error:(NSError *)error{
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        PCUserLevelDTO *dto = [PCUserLevelDTO yy_modelWithDictionary:dataDic];
        return dto;
    }
    return nil;
}

@end
