//
//  PCPasswordLoginService.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseService.h"
#import "PCPasswordLoginRequestDTO.h"

@interface PCPasswordLoginService : ACBaseService

- (void)requestPasswordLoginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(id data))success failed:(void(^)(NSError *error))failed ;

@end
