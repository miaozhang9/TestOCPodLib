//
//  AuthRequestQueue.m
//  DataYesDrJ
//
//  Created by jia.wang on 14/11/28.
//  Copyright (c) 2014年 jia.wang. All rights reserved.
//

#import "CDBaseRequestQueue.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "CDBaseHttpRequest.h"
#import "CredooApiFrameworkConst.h"
#import "CDHttpErrorCodeHandler.h"
#import "CDBaseAuthService.h"
#import "CDBaseAuthService.h"
#import "CredooApiFramework.h"
#import "NSString+Addtion.h"
#import "ACAppConstant.h"
@interface CDBaseRequestQueue()

@end

@implementation CDBaseRequestQueue

+ (CDBaseRequestQueue *)sharedAuthRequestQueue {
    static CDBaseRequestQueue *queue;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^ {
        queue = [[CDBaseRequestQueue alloc] init];
        [queue initial];
    });
    
    return queue;
}

-(void)initial{
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
#ifdef DEBUG
    if([[CredooApiFramework sharedInstance].httpRequestUrls[0] containsString:@"https://"]){
        AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [policy setValidatesDomainName:NO];
        [policy setAllowInvalidCertificates:YES];
        self.securityPolicy = policy;
    }
#else
    //读取cer文件
//     [self supportSSLWithURL:[NSURL URLWithString:[CredooApiFramework sharedInstance].httpRequestUrls[0]]];
    //读取cer转成的String
    [self supportSSLCerWithURL:[NSURL URLWithString:[CredooApiFramework sharedInstance].httpRequestUrls[0]]];
    
#endif

}



-(void)supportSSLCerWithURL:(NSURL *)url{
    NSString *urlStr = [url absoluteString];
    if ([urlStr rangeOfString:@"https://qhcs-qjj.credoo.com.cn"].location != NSNotFound) {
        [self setSecurityPolicy:[self securityPolicyWithCerBase64Str:CERBase64_qjj_pro]];
    }else if([urlStr rangeOfString:@"https://rmgs.pingan.com"].location != NSNotFound){
        [self setSecurityPolicy:[self securityPolicyWithCerBase64Str:CERBase64_loan_pro]];
    }else if([urlStr rangeOfString:@"https://qhcs-qjj-stg.credoo.com.cn:33443"].location != NSNotFound){
        [self setSecurityPolicy:[self securityPolicyWithCerBase64Str:CERBase64_qjj_stg1]];
    }else if([urlStr rangeOfString:@"https://test-p2pp-loan-stg.pingan.com.cn"].location != NSNotFound){
        [self setSecurityPolicy:[self securityPolicyWithCerBase64Str:CERBase64_loan_stg1]];
    }else{
        AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        [policy setValidatesDomainName:YES];
        [policy setAllowInvalidCertificates:NO];
        self.securityPolicy = policy;
    }
}

- (AFSecurityPolicy*)securityPolicyWithCerBase64Str:(NSString *)cerBase64Str
{
    //    // /先导入证书
    //    NSString *cerPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"loan_pro" ofType:@"cer"];//证书的路径
    //    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //  NSString *str2 = [NSString dataToBase64:certData];
    NSData *certData = [NSString base64ToData:cerBase64Str];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    
    securityPolicy.validatesDomainName = YES;
    
    securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];
    
    return securityPolicy;
}

-(void)supportSSLWithURL:(NSURL *)url{
    NSString *urlStr = [url absoluteString];
    if ([urlStr rangeOfString:@"https://qhcs-qjj.credoo.com.cn"].location != NSNotFound) {
        [self setSecurityPolicy:[self securityPolicyWithFileName:@"qjj_pro"]];
    }else if([urlStr rangeOfString:@"https://rmgs.pingan.com"].location != NSNotFound){
        [self setSecurityPolicy:[self securityPolicyWithFileName:@"loan_pro"]];
    }else if([urlStr rangeOfString:@"https://qhcs-qjj-stg.credoo.com.cn:33443"].location != NSNotFound){
        [self setSecurityPolicy:[self securityPolicyWithFileName:@"qjj_stg1"]];
    }else if([urlStr rangeOfString:@"https://test-p2pp-loan-stg.pingan.com.cn"].location != NSNotFound){
        [self setSecurityPolicy:[self securityPolicyWithFileName:@"loan_stg1"]];
    }else{
        AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        [policy setValidatesDomainName:YES];
        [policy setAllowInvalidCertificates:NO];
        self.securityPolicy = policy;
    }
}
- (AFSecurityPolicy*)securityPolicyWithFileName:(NSString *)name
{
    // /先导入证书
    NSString *cerPath = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    
    securityPolicy.validatesDomainName = YES;
    
    securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];
    
    return securityPolicy;
}


- (void)loadReachabilityManager {

}

- (NSURLSessionTask *)generateBasePostTaskWithRequest:(CDBaseHttpRequest *)request {
    NSURLSessionTask    *task;
    NSMutableURLRequest *urlRequest;

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[CredooApiFramework sharedInstance].httpRequestUrls[request.requestDTO.serverUrlType],request.requestDTO.methodName];
    
    
    urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [urlRequest setTimeoutInterval:kHTTPTimeout];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    [request.requestDTO generateCommonParamDic];
    [request.requestDTO generateSign];
    
    NSMutableString *postMulStr = [[NSMutableString alloc] init];
    [request.requestDTO.paramDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [postMulStr appendFormat:@"%@=%@&",[self urlencodedValue:key],[[obj class] isSubclassOfClass:[NSString class]] ? [self urlencodedValue:obj] : obj];
    }];
    if (postMulStr.length>0) {
        NSString *postStr = [postMulStr substringToIndex:[postMulStr length]-1];
        [urlRequest setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    }
    __weak typeof(self) weakSelf = self;
    task = [self dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (request.failed) {
                request.failed([CDHttpErrorCodeHandler errorWithCode:error.code userinfo:error.userInfo originError:nil]);
            }
        } else if (responseObject) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf handleResponseDataForSuccess:(NSInteger)[(NSHTTPURLResponse *)response statusCode] response:response responseObject:responseObject authRequest:request success:request.success failed:request.failed];
        }
    }];
    return task;
}

- (NSURLSessionTask *)generatePostTaskWithRequest:(CDBaseHttpRequest *)request{
    return [self generateBasePostTaskWithRequest:request];
}

- (NSURLSessionTask *)generatePostTaskWithRequestForMock:(CDBaseHttpRequest *)request {
    return [self generateBasePostTaskWithRequest:request];
}


- (void)handleResponseDataForSuccess:(NSInteger)statusCode response:(id)response responseObject:(id)responseObject authRequest:(CDBaseHttpRequest *)request success:(SuccessBlock)success failed:(FailedBlock)failed {
#ifdef DEBUG
    NSLog(@"requestMethodName === %@; responseObject === %@",request.requestDTO.methodName, responseObject);
#endif
    if (statusCode == 200) {
        NSError *error = nil;
        if ([responseObject objectForKey:@"code"] != nil && [[responseObject objectForKey:@"code"] intValue] != 0) {
            error = [NSError errorWithDomain:[responseObject objectForKey:@"message"] code:[[responseObject objectForKey:@"code"] intValue] userInfo:nil];
            
            int code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 1003 || code == 2200) {
               // if (request.requestDTO.securityType == SecurityType_UserMustLogin) {
                    //登录失效，重新登录
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRelogin object:nil];
                    [CDBaseAuthService clearAuthWithoutLogin];
               // }
                BLOCK(failed)([CDHttpErrorCodeHandler errorWithCode:error.code userinfo:error.userInfo originError:error]);
            } else {
                BLOCK(failed)([CDHttpErrorCodeHandler errorWithCode:error.code userinfo:error.userInfo originError:error]);
            }
        } else {
            id result = [request.requestDTO getResponseByData:[responseObject objectForKey:@"data"] error:error==nil?nil:&error];
            
            BLOCK(success)(result);
        }
    } else {
        BLOCK(failed)([NSError errorWithDomain:@"服务器异常" code:statusCode userInfo:nil]);
    }
}

- (void)cancelAll {
     [self.operationQueue cancelAllOperations];
}

- (NSString*)urlencodedValue:(NSString *)value {
    NSString* urlencodedString = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)value, NULL, CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return urlencodedString;
}

@end
