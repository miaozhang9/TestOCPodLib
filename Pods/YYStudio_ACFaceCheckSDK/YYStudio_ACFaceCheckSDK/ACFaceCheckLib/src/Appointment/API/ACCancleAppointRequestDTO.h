//
//  PCCancleAppointRequestDTO.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "CredooApiFramework.h"

@interface ACCancleAppointRequestDTO : CDBaseRequestDTO
- (void)generateParamWithOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey;
@end
