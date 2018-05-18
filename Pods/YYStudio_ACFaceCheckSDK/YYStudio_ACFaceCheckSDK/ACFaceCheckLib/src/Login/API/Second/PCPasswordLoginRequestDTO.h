//
//  PCPasswordLoginRequestDTO.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "CredooApiFramework.h"
#import "PCUserAuthDTO.h"

@interface PCPasswordLoginRequestDTO : CDBaseRequestDTOForAuth

- (void)generateParamWithPhone:(NSString *)phone password:(NSString *)password;

@end
