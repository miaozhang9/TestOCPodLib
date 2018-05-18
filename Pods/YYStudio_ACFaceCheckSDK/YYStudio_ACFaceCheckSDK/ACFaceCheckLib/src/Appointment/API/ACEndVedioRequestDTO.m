//
//  PCEndVedioRequestDTO.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/9/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACEndVedioRequestDTO.h"

@implementation ACEndVedioRequestDTO
- (instancetype)init {
    self = [super init];
    if (self) {
        self.methodName = @"/qjj_app/anychatqueue/videocall/finish";
        self.securityType = SecurityType_UserMustLogin;
    }
    return self;
}

- (void)generateParamWithayUserIdFrom:(NSString *)ayUserIdFrom ayUserIdTo:(NSString *)ayUserIdTo isException:(NSString *)isException{
    [self generateParamDic:@{@"ayUserIdFrom":ayUserIdFrom?:@"",@"ayUserIdTo":ayUserIdTo?:@"",@"isException":isException?:@""}];
}

- (id)getResponseByData:(id)dataDic error:(NSError *__autoreleasing *)error{
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        return [NSNumber numberWithBool:YES];
    }
    return nil;
}

@end
