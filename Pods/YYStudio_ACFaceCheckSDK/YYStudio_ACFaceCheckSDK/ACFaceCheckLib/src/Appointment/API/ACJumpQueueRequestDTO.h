//
//  PCJumpQueueRequestDTO.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/9/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "CredooApiFramework.h"

@interface ACJumpQueueRequestDTO : CDBaseRequestDTO
- (void)generateParamWithchannelId:(NSString *)channelId phone:(NSString *)phone;
@end
