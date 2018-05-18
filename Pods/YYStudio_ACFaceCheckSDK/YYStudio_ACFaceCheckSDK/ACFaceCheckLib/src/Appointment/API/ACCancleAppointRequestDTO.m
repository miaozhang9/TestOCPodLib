//
//  PCCancleAppointRequestDTO.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACCancleAppointRequestDTO.h"

@implementation ACCancleAppointRequestDTO
- (instancetype)init {
    self = [super init];
    if (self) {
        self.methodName = @"/qjj_app/anyloan/appoint/client/cancel";
        self.securityType = SecurityType_UserMustLogin;
    }
    return self;
}

- (void)generateParamWithOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey{
    [self generateParamDic:@{@"appointNo":orderId?:@"",@"appointSecretKey":appointSecretKey?:@""}];
}

- (id)getResponseByData:(id)dataDic error:(NSError *__autoreleasing *)error{
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        return [NSNumber numberWithBool:YES];
    }
    return nil;
}

@end
