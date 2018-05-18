//
//  PCEndVedioRequestDTO.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/9/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "CredooApiFramework.h"

@interface ACEndVedioRequestDTO : CDBaseRequestDTO

- (void)generateParamWithayUserIdFrom:(NSString *)ayUserIdFrom ayUserIdTo:(NSString *)ayUserIdTo isException:(NSString *)isException;
@end
