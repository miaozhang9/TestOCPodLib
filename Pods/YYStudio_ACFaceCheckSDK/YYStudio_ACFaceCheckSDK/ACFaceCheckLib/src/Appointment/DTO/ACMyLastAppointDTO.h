//
//  PCMyLastAppointDTO.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseDTO.h"
//ata": {
//"appointNo": 4,
//"startTime": 1503471600000,
//"appointCreate": 0,
//"responseCode": "success",
//"queueAvailable": 1,
//"appointUpdate": 0,
//"appointSecretKey": "lalalallaalal",
//"isQueuing": 0,
//"slot": 28,
//"endTime": 1503473400000
@interface ACMyLastAppointDTO : ACBaseDTO
//预约编号
@property(nonatomic,copy)NSString *appointno;
//秘钥
@property(nonatomic,copy)NSString *appointsecretkey;
//预约开始时间
@property(nonatomic,copy)NSString *starttime;
//预约结束时间
@property(nonatomic,copy)NSString *endtime;
//时间槽
@property(nonatomic,copy)NSString *slot;
//(1：排队中，0：不在排队)
@property(nonatomic,copy)NSString *isqueuing;
//（1：可面签，0：不可面签）
@property(nonatomic,copy)NSString *queueavailable;
//（1：可修改、取消预约，0：不可修改、取消预约）
@property(nonatomic,copy)NSString *appointupdate;
//（1：可发起预约，0：不可发起预约）
@property(nonatomic,copy)NSString *appointcreate;
//（1:该预约是今天的，且过号）
@property(nonatomic,copy)NSString *isPassToday;

// 1：在可面签时间内，但在其它队列排队中)
@property (nonatomic,copy) NSString *queuingInother;

    
@end
