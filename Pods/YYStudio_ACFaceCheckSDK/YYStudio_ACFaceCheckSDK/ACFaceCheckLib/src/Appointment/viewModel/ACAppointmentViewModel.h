//
//  PCAppointmentViewModel.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseViewModel.h"

@interface ACAppointmentViewModel : ACBaseViewModel
    //获取最近面核预约
-(void)myLasteAppointRequestSignalWithPhone:(NSString *)phone success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
    //获取面核预约时间列表
-(void)getAvailableListDateRequestSignalWithisPassToday:(NSString *)isPassToday success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
    //预约面签
-(void)creatAppointRequestSignalWithOrderId:(NSString *)orderId appointDate:(NSString *)date slot:(NSString *)slot productName:(NSString *)productName success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
    //取消预约
- (void)cancleAppointRequestSignalWithAppointno:(NSString *)appointno appointSecretKey:(NSString *)appointSecretKey success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
    //预约改期
- (void)changeAppointRequestSignalWithAppointno:(NSString *)appointno appointSecretKey:(NSString *)appointSecretKey appointDate:(NSString *)date slot:(NSString *)slot success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
    //发起面签
-(void)joinAppointRequestSignalWithOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
    //放弃排队
-(void)leaveQueueleaveQueueWithphone:(NSString *)phone success:(void (^)(id))success failed:(void (^)(NSError *))failed;
//结束视频
- (void)endVedioRequestSignalWithayUserIdFrom:(NSString *)ayUserIdFrom ayUserIdTo:(NSString *)ayUserIdTo isException:(NSString *)isException success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
//插队
- (void)jumpQueueRequestSignalWithchannelId:(NSString *)channelId phone:(NSString *)phone success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
@end
