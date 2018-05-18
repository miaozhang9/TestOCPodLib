//
//  PCGetSmsCoderService.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCGetSmsCoderService.h"
#import "PCGetSmsCoderRequestDTO.h"

@implementation PCGetSmsCoderService

- (void)getSmsCoderWithType:(NSString *)type vUid:(NSString *)vUid captchaCode:(NSString *)captchaCode phone:(NSString *)phone success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        PCGetSmsCoderRequestDTO *dto = [[PCGetSmsCoderRequestDTO alloc]init];
        // 设置参数
        [dto generateParamWithType:type vUid:vUid captchaCode:captchaCode phone:phone];
        CDHttpReqestForAuth *request = [[CDHttpReqestForAuth alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(PCVcodeDTO *responseObj) {
            success(responseObj);
        } failed:^(NSError *error) {
            failed(error);
        }];
//    }];
}

@end
