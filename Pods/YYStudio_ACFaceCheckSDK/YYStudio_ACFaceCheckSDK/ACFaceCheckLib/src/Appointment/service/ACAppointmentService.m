//
//  PCAppointmentService.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACAppointmentService.h"
#import "ACAvailableRequestDTO.h"
#import "ACCreatAppointRequestDTO.h"
#import "ACCancleAppointRequestDTO.h"
#import "ACModifyRequestDTO.h"
#import "ACMyLastAppointRequestDTO.h"
#import "ACJoinAppointmentRequestDTO.h"
#import "ACEndVedioRequestDTO.h"
#import "ACJumpQueueRequestDTO.h"
#import "ACLeaveQueueRequestDTO.h"
@implementation ACAppointmentService
- (void)myLasteAppointWithPhone:(NSString *)phone success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        ACMyLastAppointRequestDTO *dto = [[ACMyLastAppointRequestDTO alloc]init];
        [dto generateParamWithtPhone:phone];
        CDHttpReqestForAuth *request = [[CDHttpReqestForAuth alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(id responseObj) {
            success(responseObj);
        } failed:^(NSError *error) {
            failed(error);
        }];
//    }];
}

- (void)getAvailableListDateWithisPassToday:(NSString *)isPassToday success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        ACAvailableRequestDTO *dto = [[ACAvailableRequestDTO alloc]init];
        [dto generateParamWithisPassToday:isPassToday];
        CDHttpReqestForAuth *request = [[CDHttpReqestForAuth alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(id responseObj) {
            success(responseObj);
        } failed:^(NSError *error) {
            failed(error);
        }];
//    }];
}

- (void)creatAppointWithOrderId:(NSString *)orderId appointDate:(NSString *)date slot:(NSString *)slot productName:(NSString *)productName success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        ACCreatAppointRequestDTO *dto = [[ACCreatAppointRequestDTO alloc]init];
        [dto generateParamWithtOrderId:orderId appointDate:date slot:slot productName:productName];
        CDPostHttpRequest *request = [[CDPostHttpRequest alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(id responseObj) {
            success(responseObj);
        } failed:^(NSError *error) {
            failed(error);
        }];
//    }];
}

- (void)cancleAppointWithOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        ACCancleAppointRequestDTO *dto = [[ACCancleAppointRequestDTO alloc]init];
        [dto generateParamWithOrderId:orderId appointSecretKey:appointSecretKey];
        CDPostHttpRequest *request = [[CDPostHttpRequest alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(id responseObj) {
            success(responseObj);
        } failed:^(NSError *error) {
            failed(error);
        }];
//    }];

}
- (void)changeAppointWithAppointno:(NSString *)appointno appointSecretKey:(NSString *)appointSecretKey appointDate:(NSString *)date slot:(NSString *)slot success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        ACModifyRequestDTO *dto = [[ACModifyRequestDTO alloc]init];
        [dto generateParamWithtOrderId:appointno appointSecretKey:appointSecretKey appointDate:date slot:slot];
        CDPostHttpRequest *request = [[CDPostHttpRequest alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(id responseObj) {
            success(responseObj);
        } failed:^(NSError *error) {
            failed(error);
        }];
//    }];
}

- (void)joinAppointWithOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        ACJoinAppointmentRequestDTO *dto = [[ACJoinAppointmentRequestDTO alloc]init];
        [dto generateParamWithOrderId:orderId appointSecretKey:appointSecretKey];
        CDPostHttpRequest *request = [[CDPostHttpRequest alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(id responseObj) {
            success(responseObj);
        } failed:^(NSError *error) {
            failed(error);
        }];
//    }];
    
}
-(void)endVedioWithayUserIdFrom:(NSString *)ayUserIdFrom ayUserIdTo:(NSString *)ayUserIdTo isException:(NSString *)isException success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        ACEndVedioRequestDTO *dto = [[ACEndVedioRequestDTO alloc]init];
        [dto generateParamWithayUserIdFrom:ayUserIdFrom ayUserIdTo:ayUserIdTo isException:isException];
        CDPostHttpRequest *request = [[CDPostHttpRequest alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(id responseObj) {
            success(responseObj);
        } failed:^(NSError *error) {
            failed(error);
        }];
//    }];

}
- (void)jumpQueueWithchannelId:(NSString *)channelId phone:(NSString *)phone success:(void (^)(id data))success failed:(void(^)(NSError *error))failed {
//    return [PMKPromise promiseWithResolver:^(PMKResolver resolve){
        ACJumpQueueRequestDTO *dto = [[ACJumpQueueRequestDTO alloc]init];
        [dto generateParamWithchannelId:channelId phone:phone];
        CDPostHttpRequest *request = [[CDPostHttpRequest alloc]init];
        request.requestDTO = dto;
        [request startRequestWithSuccess:^(id responseObj) {
            success(responseObj);
        } failed:^(NSError *error) {
            failed(error);
        }];
//    }];
    
}
-(void)leaveQueueWithphone:(NSString *)phone success:(void (^)(id))success failed:(void (^)(NSError *))failed{
    ACLeaveQueueRequestDTO *dto = [[ACLeaveQueueRequestDTO alloc]init];
    [dto generateParamWithisPhone:phone];
    CDPostHttpRequest *request = [[CDPostHttpRequest alloc]init];
    request.requestDTO = dto;
    [request startRequestWithSuccess:^(id responseObj) {
        success(responseObj);
    } failed:^(NSError *error) {
        failed(error);
    }];
}
@end
