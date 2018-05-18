//
//  CPMyLastAppointRequestDTO.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACMyLastAppointRequestDTO.h"

#import "ACMyLastAppointDTO.h"
#import <YYModel/YYModel.h>

@implementation ACMyLastAppointRequestDTO
- (instancetype)init {
    self = [super init];
    if (self) {
        self.methodName = @"/qjj_app/anyloan/appoint/client/myLatest";
        self.httpMethod = HttpMethodGet;
    }
    return self;
}

- (void)generateParamWithtPhone:(NSString *)phone {
    [self generateParamDic:@{@"phone":phone?:@""}];
}

- (id)getResponseByData:(NSDictionary *)dataDic error:(NSError *)error {
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        ACMyLastAppointDTO *dto = [ACMyLastAppointDTO yy_modelWithDictionary:dataDic];
        return dto;
    }
    return nil;
}
@end
