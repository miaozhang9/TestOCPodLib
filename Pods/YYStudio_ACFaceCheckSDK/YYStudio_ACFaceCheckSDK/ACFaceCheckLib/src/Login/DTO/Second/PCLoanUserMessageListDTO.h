//
//  PCLoanUserMessageDto.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/23.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseDTO.h"

@class PCLoanUserMessageDTO;

@interface PCLoanUserMessageListDTO : ACBaseDTO

@property (nonatomic, strong) NSArray<PCLoanUserMessageDTO *> *users;

@end

@interface PCLoanUserMessageDTO : ACBaseDTO

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *idNo;
@property (nonatomic, copy) NSString *name;

@end
