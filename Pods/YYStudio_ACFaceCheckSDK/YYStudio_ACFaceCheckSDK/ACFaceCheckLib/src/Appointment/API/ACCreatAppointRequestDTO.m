//
//  PCCreatAppointRequestDTO.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACCreatAppointRequestDTO.h"

#import "ACCreatAppointDTO.h"
#import <YYModel/YYModel.h>
#import "NSNumber+Addtion.h"

@implementation ACCreatAppointRequestDTO
- (instancetype)init {
    self = [super init];
    if (self) {
        self.methodName = @"/qjj_app/anyloan/appoint/client/create";
        self.securityType = SecurityType_UserMustLogin;
    }
    return self;
}

- (void)generateParamWithtOrderId:(NSString *)orderId appointDate:(NSString *)date slot:(NSString *)slot productName:(NSString *)productName{
    [self generateParamDic:@{@"orderId":orderId?:@"",@"appointDate":date?:@"",@"slot":[NSNumber pc_numberWithString:slot],@"productName":productName?:@""}];
}

- (id)getResponseByData:(NSDictionary *)dataDic error:(NSError *__autoreleasing *)error {
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        ACCreatAppointDTO *dto = [ACCreatAppointDTO yy_modelWithDictionary:dataDic];
        return dto;
    }
    return nil;
}

@end
