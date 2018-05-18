//
//  DYHttpReqestForAuth.m
//  DataYesDrJ
//
//  Created by jia.wang on 14/11/27.
//  Copyright (c) 2014年 jia.wang. All rights reserved.
//

#import "CDHttpReqestForAuth.h"
#import "CDAuthRequestQueue.h"
#import "CredooApiFramework.h"

@interface CDHttpReqestForAuth(){
    BOOL _isStop;
}

@property (assign, nonatomic) NSURLSessionTask    *requestOperation;

@end

@implementation CDHttpReqestForAuth

@synthesize requestOperation,requestDTO;

-(void)startRequestWithSuccess:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed{
    if(_isStop)
        return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        if (self.requestDTO.otherUrl.length > 0) {
            [[CDAuthRequestQueue sharedAuthRequestQueue] setBaseRequestUrl:self.requestDTO.otherUrl];
        } else {
            [[CDAuthRequestQueue sharedAuthRequestQueue] setBaseRequestUrl:[CredooApiFramework sharedInstance].httpRequestUrls[0]];
        }
        self.requestOperation = [[CDAuthRequestQueue sharedAuthRequestQueue] startRequestOperation:self success:^(id responseDTO) {
            if(_isStop)
                return;
            success(responseDTO);
        } failed:^(NSError *error) {
            if(_isStop)
                return;
            failed([CDHttpErrorCodeHandler errorWithCode:error.code userinfo:error.userInfo originError:error]);
        }];
    });
}

-(void)cancelRequest{
    _isStop = YES;
    
//    for(NSOperation *op in [AuthRequestQueue sharedAuthRequestQueue].operationQueue.operations){
//        if(op == requestOperation){
//            [requestOperation cancel];
//            break;
//        }
//    }
}

@end
