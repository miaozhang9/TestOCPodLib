//
//  AuthRequestQueue.h
//  CredooApiFramework
//
//  Created by 徐佳良 on 2016/11/3.
//  Copyright © 2016年 Credoo. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CDHttpReqestForAuth.h"

@interface CDAuthRequestQueue : AFHTTPSessionManager

+(CDAuthRequestQueue *)sharedAuthRequestQueue;

-(void)setBaseRequestUrl:(NSString *)baseRequestUrl;

-(NSURLSessionTask *)startRequestOperation:(CDHttpReqestForAuth *)request success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
-(NSURLSessionTask *)startRequestOperationForMock:(CDHttpReqestForAuth *)request success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;

-(void)cancelAll;

-(void)handleResponseDataForSuccess:(NSInteger)statusCode response:response responseObject:(id)responseObject authRequest:(CDHttpReqestForAuth *)request success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;

@end
