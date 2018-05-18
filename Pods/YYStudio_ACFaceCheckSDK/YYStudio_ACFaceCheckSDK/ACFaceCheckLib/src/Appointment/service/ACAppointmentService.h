//
//  PCAppointmentService.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseService.h"

@interface ACAppointmentService : ACBaseService
//获取最近面核预约
- (void)myLasteAppointWithPhone:(NSString *)phone success:(void (^)(id data))success failed:(void(^)(NSError *error))failed ;
//获取面核预约时间列表
- (void)getAvailableListDateWithisPassToday:(NSString *)isPassToday success:(void (^)(id data))success failed:(void(^)(NSError *error))failed ;
//预约时间
- (void)creatAppointWithOrderId:(NSString *)orderId appointDate:(NSString *)date slot:(NSString *)slot productName:(NSString *)productName success:(void (^)(id data))success failed:(void(^)(NSError *error))failed ;
//取消预约
- (void)cancleAppointWithOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey success:(void (^)(id data))success failed:(void(^)(NSError *error))failed ;
//预约改期
- (void)changeAppointWithAppointno:(NSString *)appointno appointSecretKey:(NSString *)appointSecretKey appointDate:(NSString *)date slot:(NSString *)slot success:(void (^)(id data))success failed:(void(^)(NSError *error))failed ;
//发起面签／开始排队
- (void)joinAppointWithOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey success:(void (^)(id data))success failed:(void(^)(NSError *error))failed ;
//结束视频(0：主动挂断；1：异常中断  异常中断会直接进入插队后台自己做的)
- (void)endVedioWithayUserIdFrom:(NSString *)ayUserIdFrom ayUserIdTo:(NSString *)ayUserIdTo isException:(NSString *)isException success:(void (^)(id data))success failed:(void(^)(NSError *error))failed ;
//插队
- (void)jumpQueueWithchannelId:(NSString *)channelId phone:(NSString *)phone success:(void (^)(id data))success failed:(void(^)(NSError *error))failed ;
//离队
-(void)leaveQueueWithphone:(NSString *)phone success:(void (^)(id))success failed:(void (^)(NSError *))failed;


@end
