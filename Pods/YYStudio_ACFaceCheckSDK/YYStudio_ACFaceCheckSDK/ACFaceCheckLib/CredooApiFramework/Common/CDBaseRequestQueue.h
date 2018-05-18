//
//  AuthRequestQueue.h
//  DataYesDrJ
//
//  Created by jia.wang on 14/11/28.
//  Copyright (c) 2014年 jia.wang. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
//#import "CDBaseHttpRequest.h"
@class CDBaseHttpRequest;

typedef void(^ProgressBlock)(NSProgress *progress);
typedef void(^SuccessBlock)(id responseObj);
typedef void(^FailedBlock)(NSError *error);

@interface CDBaseRequestQueue : AFHTTPSessionManager


+(CDBaseRequestQueue *)sharedAuthRequestQueue;

- (NSURLSessionTask *)generateBasePostTaskWithRequest:(CDBaseHttpRequest *)request;

- (NSURLSessionTask *)generatePostTaskWithRequest:(CDBaseHttpRequest *)request;
- (NSURLSessionTask *)generatePostTaskWithRequestForMock:(CDBaseHttpRequest *)request;

-(void)cancelAll;

-(void)handleResponseDataForSuccess:(NSInteger)statusCode response:(id)response  responseObject:(id)responseObject authRequest:(CDBaseHttpRequest *)request success:(SuccessBlock)success failed:(FailedBlock)failed;

- (NSString*)urlencodedValue:(NSString *)value;
@end
