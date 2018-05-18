//
//  CPMyLastAppointRequestDTO.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "CredooApiFramework.h"

@interface ACMyLastAppointRequestDTO : CDBaseRequestDTOForAuth
- (void)generateParamWithtPhone:(NSString *)orderId;
@end
