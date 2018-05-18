//
//  PCGetCaptchaService.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCGetCaptchaService.h"
#import "PCGetCaptchaRequestDTO.h"
#import "PCImgCaptchaDTO.h"

@implementation PCGetCaptchaService

- (void)getImgCaptchaWithType:(NSString *)type success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        PCGetCaptchaRequestDTO *dto = [[PCGetCaptchaRequestDTO alloc]init];
        // 无设置参数
        [dto generateParamWithType:type];
        CDHttpReqestForAuth *request = [[CDHttpReqestForAuth alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(PCImgCaptchaDTO *responseObj) {
            success(responseObj);
        } failed:^(NSError *error) {
            failed(error);
        }];
        
//    }];
}

@end
