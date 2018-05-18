//
//  DYHttpReqestForAuth.h
//  DataYesDrJ
//
//  Created by jia.wang on 14/11/27.
//  Copyright (c) 2014年 jia.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "CDBaseRequestDTOForAuth.h"

@interface CDHttpReqestForAuth : NSObject

@property (strong, nonatomic) CDBaseRequestDTOForAuth        *requestDTO;

-(void)startRequestWithSuccess:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
-(void)cancelRequest;

@end
