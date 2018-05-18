//
//  PCPasswordLoginRequestDTO.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCPasswordLoginRequestDTO.h"
#import <TMCache/TMCache.h>
#import "ACAppConstant.h"
#import "PCUserLevelService.h"
#import <YYModel/YYModel.h>
#import "UIDevice+Credoo.h"

@implementation PCPasswordLoginRequestDTO

- (instancetype)init{
    if (self = [super init]) {
        self.methodName = @"/qjj_app/anyloan/nologin/user/login";
        self.httpMethod = HttpMethodPost;
    }
    return self;
}

- (void)generateParamWithPhone:(NSString *)phone password:(NSString *)password {
    [self generateParamDic:@{@"password":[self md5WithPassword:password] ? : @"", @"phone":phone}];
}

- (NSString*)md5WithPassword:(NSString*)str{
    str = [NSString stringWithFormat:@"%@credoo",str.credoo_md5String];
    str = str.credoo_md5String;
    return str;
}
- (id)getResponseByData:(NSDictionary *)dataDic error:(NSError *)error{
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        PCUserAuthDTO *dto = [PCUserAuthDTO yy_modelWithDictionary:dataDic];
        [PCUserLevelService share].userAuthDTO = dto;
        return dto;
    }
    return nil;
}

@end
