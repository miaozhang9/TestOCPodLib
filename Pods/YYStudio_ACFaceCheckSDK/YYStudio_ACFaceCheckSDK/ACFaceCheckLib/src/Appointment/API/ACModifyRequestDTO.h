//
//  PCModifyRequestDTO.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "CredooApiFramework.h"

@interface ACModifyRequestDTO : CDBaseRequestDTO
- (void)generateParamWithtOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey appointDate:(NSString *)date slot:(NSString *)slot;
@end
