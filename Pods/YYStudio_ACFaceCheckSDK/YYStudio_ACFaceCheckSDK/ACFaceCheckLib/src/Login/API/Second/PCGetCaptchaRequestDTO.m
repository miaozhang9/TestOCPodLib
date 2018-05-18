//
//  PCImgCaptchaRequestDTO.m
//  PersonalCenter
//
//  Created by Miaoz on 2017/5/17.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCGetCaptchaRequestDTO.h"
#import "PCImgCaptchaDTO.h"
#import <YYModel/YYModel.h>

@implementation PCGetCaptchaRequestDTO

-(instancetype)init{
    if (self = [super init]) {
        self.methodName = @"/qjj_app/anyloan/nologin/sms/getCaptcha";
        self.httpMethod = HttpMethodPost;
    }
    return self;
}

- (void)generateParamWithType:(NSString *)type{
    [self generateParamDic:@{@"type":type}];
}

-(id)getResponseByData:(NSDictionary *)dataDic error:(NSError *)error{
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        PCImgCaptchaDTO *dto = [PCImgCaptchaDTO yy_modelWithDictionary:dataDic];
        return dto;
    }
    return nil;
}

@end
