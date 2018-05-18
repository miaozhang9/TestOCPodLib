//
//  PCJumpQueueRequestDTO.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/9/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACJumpQueueRequestDTO.h"

@implementation ACJumpQueueRequestDTO
- (instancetype)init {
    self = [super init];
    if (self) {
        self.methodName = @"/qjj_app/anychatqueue/queue/manager/jump";
        self.securityType = SecurityType_UserMustLogin;
    }
    return self;
}

- (void)generateParamWithchannelId:(NSString *)channelId phone:(NSString *)phone{
    [self generateParamDic:@{@"channelId":channelId?:@"",@"phone":phone?:@""}];
}

- (id)getResponseByData:(id)dataDic error:(NSError *__autoreleasing *)error{
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        return [NSNumber numberWithBool:YES];
    }
    return nil;
}


@end
