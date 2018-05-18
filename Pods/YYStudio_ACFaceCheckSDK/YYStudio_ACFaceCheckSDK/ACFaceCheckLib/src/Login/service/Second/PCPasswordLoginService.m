//
//  PCPasswordLoginService.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCPasswordLoginService.h"
#import "PCPasswordLoginRequestDTO.h"
#import "ACAppConstant.h"
@implementation PCPasswordLoginService

- (void)requestPasswordLoginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        PCPasswordLoginRequestDTO *dto = [[PCPasswordLoginRequestDTO alloc]init];
        // 设置参数
        [dto generateParamWithPhone:phone password:password];
        CDHttpReqestForAuth *request = [[CDHttpReqestForAuth alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(id responseObj) {
            success(responseObj);
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
        } failed:^(NSError *error) {
            failed(error);
        }];
//    }];
}

@end
