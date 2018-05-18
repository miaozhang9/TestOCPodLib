//
//  DYHttpReqestForAuth.h
//  DataYesDrJ
//
//  Created by jia.wang on 14/11/27.
//  Copyright (c) 2014年 jia.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "CDBaseRequestDTO.h"
#import "CDBaseRequestQueue.h"

// 判断此Block是否未nil，不为nil才调用，格式  BLOCK(<#SomeBlock#>)(<#returnValues#>)
#define BLOCK(BLOCK) if(BLOCK) BLOCK

@interface CDBaseHttpRequest : NSObject{
    BOOL _isStop;
}

@property (strong, nonatomic) CDBaseRequestDTO      *requestDTO;
@property (strong, nonatomic) NSURLSessionTask *task;

@property (nonatomic, copy) SuccessBlock  success;
@property (nonatomic, copy) FailedBlock   failed;

- (instancetype)initWithRequestDTO:(CDBaseRequestDTO *)requestDTO;

/**
 *  立即开始请求任务,若不希望已经更改引用的success与failed使用 "startRequest"
 */
- (void)startRequestWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

/// 当调用startRequest并task为空时将调用，实现由子类实现
- (void)generateTask;

/// 快速设置success以及failed
- (void)handleSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

/**
 *  开始请求的代码，在子类进行实现，从而分离各式各样的请求的代码
 */
- (void)startRequest;
- (void)cancelRequest;
- (void)suspendRequest;


@end
