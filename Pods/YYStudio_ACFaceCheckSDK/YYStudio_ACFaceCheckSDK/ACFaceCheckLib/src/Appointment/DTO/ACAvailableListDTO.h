//
//  AvailableDTO.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseDTO.h"

@class ACAvailableDayDTO;

@interface ACAvailableListDTO : ACBaseDTO

@property (nonatomic,strong)NSArray<ACAvailableDayDTO *> *schedules;

@end

@class ACAvailableDTO;

@interface ACAvailableDayDTO : ACBaseDTO
//预约日期
@property (nonatomic,copy) NSString *appointdate;
// 预约是今天的且过号
@property (nonatomic,copy) NSString *isPassToday;
//秘钥
@property (nonatomic,copy)NSArray<ACAvailableDTO *> *slots;

@end

@interface ACAvailableDTO : ACBaseDTO
//第几个槽
@property (nonatomic,copy)NSString *slot;
//开始时间 HH：mm
@property (nonatomic,copy)NSString *starttime;
//结束时间 HH：mm
@property (nonatomic,copy)NSString *endtime;
//还可以预约几个
@property (nonatomic,copy)NSString *availablecount;
//预约总数
@property (nonatomic,copy)NSString *totalcount;
//预约日期
@property (nonatomic,copy)NSString *appointdate;

// 预约是今天的且过号
@property (nonatomic,copy) NSString *isPassToday;

@end
