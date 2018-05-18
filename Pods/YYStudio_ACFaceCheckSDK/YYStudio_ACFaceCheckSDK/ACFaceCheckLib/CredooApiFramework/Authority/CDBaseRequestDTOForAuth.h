//
//  BaseRequestForAuth.h
//  DataYesDrJ
//
//  Created by jia.wang on 14/11/27.
//  Copyright (c) 2014年 jia.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDHttpErrorCodeHandler.h"

typedef enum{
    HttpMethodPost = 0,
    HttpMethodGet = 1,
    HttpMethodPut = 2,
    HttpMethodUploadFile=3,
    HttpMethodDownloadFile=4
}HttpMethod;

@interface CDBaseRequestDTOForAuth : NSObject

@property (strong, nonatomic) NSString *methodName;
@property (retain, nonatomic) NSMutableDictionary *paramDic;
@property (assign, nonatomic) HttpMethod httpMethod;
@property (assign, nonatomic) BOOL isMustLogin;

@property (copy, nonatomic) NSString *otherUrl; // 特殊接口的链接
@property (copy, nonatomic) NSString *otherHttpSignPrefix; // 特殊接口的签名
@property (copy, nonatomic) NSString *otherHttpSignSurfix; // 特殊接口的签名
@property (copy, nonatomic) NSString *successCode; // 特殊接口的请求成功code

-(void)generateCommonParamDic;
-(void)generateParamDic:(NSDictionary *)param;

-(void)generateSign;

-(id)getResponseByData:(NSDictionary *)dataDic error:(NSError *)error;

-(NSString*)md5Hash:(NSString *)string;

@end
