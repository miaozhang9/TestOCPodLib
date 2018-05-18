//
//  DYHttpReqestForAuth.m
//  DataYesDrJ
//
//  Created by jia.wang on 14/11/27.
//  Copyright (c) 2014年 jia.wang. All rights reserved.
//

#import "CDBaseHttpRequest.h"
#import "CredooApiFramework.h"
#import <TMCache/TMCache.h>
@interface CDBaseHttpRequest()

@end

@implementation CDBaseHttpRequest

- (instancetype)initWithRequestDTO:(CDBaseRequestDTO *)requestDTO {
    if (self = [super init]) {
        self.requestDTO = requestDTO;
    }
    return self;
}

- (void)handleSuccess:(SuccessBlock)success failed:(FailedBlock)failed {
    self.success = success;
    self.failed  = failed;
}

- (void)startRequestWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed {
    [self handleSuccess:success failed:failed];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self startRequest];
    });
}

- (void)generateTask {}

- (void)startRequest {
    if (!self.task) {
        [self generateTask];
    }
    [self.task resume];
}

-(void)cancelRequest{
    _isStop = YES;
    [self.task cancel];
}

- (void)suspendRequest {
    [self.task suspend];
}

@end
