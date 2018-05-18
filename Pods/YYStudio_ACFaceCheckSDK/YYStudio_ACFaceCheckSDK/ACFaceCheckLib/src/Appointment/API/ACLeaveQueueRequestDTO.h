//
//  ACLeaveQueueRequestDTO.h
//  ACFaceCheckLib
//
//  Created by 黄世光 on 2018/5/9.
//  Copyright © 2018年 宫健(金融壹账通客户端研发团队). All rights reserved.
//

#import "CDBaseRequestDTO.h"

@interface ACLeaveQueueRequestDTO : CDBaseRequestDTO
- (void)generateParamWithisPhone:(NSString *)phone;
@end
