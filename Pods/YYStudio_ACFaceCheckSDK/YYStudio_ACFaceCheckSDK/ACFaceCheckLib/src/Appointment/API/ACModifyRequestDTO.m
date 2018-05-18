//
//  PCModifyRequestDTO.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACModifyRequestDTO.h"

#import "NSNumber+Addtion.h"

@implementation ACModifyRequestDTO
- (instancetype)init {
    self = [super init];
    if (self) {
        self.methodName = @"/qjj_app/anyloan/appoint/client/modify";
        self.securityType = SecurityType_UserMustLogin;
    }
    return self;
}

- (void)generateParamWithtOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey appointDate:(NSString *)date slot:(NSString *)slot{
    [self generateParamDic:@{@"appointNo":orderId?:@"",@"appointSecretKey":appointSecretKey?:@"",@"appointDate":date?:@"",@"slot":[NSNumber pc_numberWithString:slot]}];
}


- (id)getResponseByData:(id)dataDic error:(NSError *__autoreleasing *)error{
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        return [NSNumber numberWithBool:YES];
    }
    return nil;
}

@end
