//
//  PCJoinAppointmentRequestDTO.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/22.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "CredooApiFramework.h"

@interface ACJoinAppointmentRequestDTO : CDBaseRequestDTO
- (void)generateParamWithOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey;
@end
