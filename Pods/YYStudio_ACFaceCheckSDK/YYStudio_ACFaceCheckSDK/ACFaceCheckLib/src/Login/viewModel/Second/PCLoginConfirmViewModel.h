//
//  PCLoginConfirmViewModel.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseViewModel.h"
#import "PCUserLevelDTO.h"

@interface PCLoginConfirmViewModel : ACBaseViewModel

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) BOOL validPassword;
@property (nonatomic, copy) NSString *passwordMsg;


//@property (nonatomic, strong) RACCommand *loginCommand;

// 密码登录
-(void)requestPasswordLoginSignalsuccess:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
@end
