//
//  PCAppointmentViewModel.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACAppointmentViewModel.h"
#import "ACAppointmentService.h"

@interface ACAppointmentViewModel()
@property(nonatomic,strong)ACAppointmentService * appointmentService;

@end
@implementation ACAppointmentViewModel

-(void)myLasteAppointRequestSignalWithPhone:(NSString *)phone success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed {
    [self.appointmentService myLasteAppointWithPhone:phone success:^(id data) {
         success(data);
    } failed:^(NSError *error) {
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
}


-(void)getAvailableListDateRequestSignalWithisPassToday:(NSString *)isPassToday success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed {
    [self.appointmentService getAvailableListDateWithisPassToday:isPassToday success:^(id data) {
         success(data);
    } failed:^(NSError *error) {
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
}



-(void)creatAppointRequestSignalWithOrderId:(NSString *)orderId appointDate:(NSString *)date slot:(NSString *)slot productName:(NSString *)productName success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed {
    
    [self.appointmentService creatAppointWithOrderId:orderId appointDate:date slot:slot productName:productName success:^(id data) {
         success(data);
    } failed:^(NSError *error) {
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
}



-(void)cancleAppointRequestSignalWithAppointno:(NSString *)appointno appointSecretKey:(NSString *)appointSecretKey success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed  {
    [self.appointmentService cancleAppointWithOrderId:appointno appointSecretKey:appointSecretKey success:^(id data) {
         success(data);
    } failed:^(NSError *error) {
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
    
}


-(void)changeAppointRequestSignalWithAppointno:(NSString *)appointno appointSecretKey:(NSString *)appointSecretKey appointDate:(NSString *)date slot:(NSString *)slot success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed {
    [self.appointmentService changeAppointWithAppointno:appointno appointSecretKey:appointSecretKey appointDate:date slot:slot success:^(id data) {
         success(data);
    } failed:^(NSError *error) {
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
    
}


-(void)joinAppointRequestSignalWithOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed {
    [self.appointmentService joinAppointWithOrderId:orderId appointSecretKey:appointSecretKey success:^(id data) {
        success(data);
    } failed:^(NSError *error) {
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
}



-(void)endVedioRequestSignalWithayUserIdFrom:(NSString *)ayUserIdFrom ayUserIdTo:(NSString *)ayUserIdTo isException:(NSString *)isException success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed {
    [self.appointmentService endVedioWithayUserIdFrom:ayUserIdFrom ayUserIdTo:ayUserIdTo isException:isException success:^(id data) {
          success(data);
    } failed:^(NSError *error) {
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
    
}


-(void)jumpQueueRequestSignalWithchannelId:(NSString *)channelId phone:(NSString *)phone success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed  {
    [self.appointmentService jumpQueueWithchannelId:channelId phone:phone success:^(id data) {
         success(data);
    } failed:^(NSError *error) {
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
    
}


-(void)leaveQueueleaveQueueWithphone:(NSString *)phone success:(void (^)(id))success failed:(void (^)(NSError *))failed{
    [self.appointmentService leaveQueueWithphone:phone success:^(id responseDTO) {
        success(responseDTO);
    } failed:^(NSError *error) {
        error = [CDHttpErrorCodeHandler errorWithCode:error.code userinfo:nil originError:error];
        failed(error);
    }];
   
}

    
-(ACAppointmentService *)appointmentService{
    if(!_appointmentService){
        self.appointmentService = [[ACAppointmentService alloc]init];
    }
    return _appointmentService;
}

@end
