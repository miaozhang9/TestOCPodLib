//
//  PCAvailableRequestDTO.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "CredooApiFramework.h"

@interface ACAvailableRequestDTO : CDBaseRequestDTOForAuth

- (void)generateParamWithisPassToday:(NSString *)isPassToday;

@end
