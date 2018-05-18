//
//  ACLeaveQueueRequestDTO.m
//  ACFaceCheckLib
//
//  Created by 黄世光 on 2018/5/9.
//  Copyright © 2018年 宫健(金融壹账通客户端研发团队). All rights reserved.
//

#import "ACLeaveQueueRequestDTO.h"

@implementation ACLeaveQueueRequestDTO
- (instancetype)init {
    self = [super init];
    if (self) {
        self.methodName = @"/qjj_app/anyloan/appoint/client/appLeave";
        self.securityType = SecurityType_UserMustLogin;
    }
    return self;
}
- (void)generateParamWithisPhone:(NSString *)phone {
    [self generateParamDic:@{@"phone":phone?:@""}];
}

- (id)getResponseByData:(id)dataDic error:(NSError *__autoreleasing *)error{
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        return [NSNumber numberWithBool:YES];
    }
    return nil;
}

@end
