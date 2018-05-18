//
//  PCUserAuthDTO.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseDTO.h"

@interface PCUserAuthDTO : ACBaseDTO<NSCoding>

@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *idNo;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,copy)NSString *userLevel;

@end
