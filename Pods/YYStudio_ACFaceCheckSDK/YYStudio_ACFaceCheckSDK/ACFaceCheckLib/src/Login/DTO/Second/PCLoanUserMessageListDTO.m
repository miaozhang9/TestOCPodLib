//
//  PCLoanUserMessageDto.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/23.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCLoanUserMessageListDTO.h"

@implementation PCLoanUserMessageListDTO

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"users" : [PCLoanUserMessageDTO class]};
}

@end

@implementation PCLoanUserMessageDTO


@end
