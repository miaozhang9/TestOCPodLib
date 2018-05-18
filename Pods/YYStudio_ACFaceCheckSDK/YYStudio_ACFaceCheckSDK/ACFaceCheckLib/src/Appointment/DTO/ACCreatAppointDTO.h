//
//  CreatAppointDTO.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseDTO.h"

@interface ACCreatAppointDTO : ACBaseDTO
//预约编号
@property (nonatomic,copy)NSString *appointNo;
//秘钥
@property (nonatomic,copy)NSString *appointSecretKey;


@end
