//
//  AuthRequestQueue.m
//  CredooApiFramework
//
//  Created by 徐佳良 on 2016/11/3.
//  Copyright © 2016年 Credoo. All rights reserved.
//

#import "CDAuthRequestQueue.h"
#import "CDHttpReqestForAuth.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "CredooApiFrameworkConst.h"
#import <TMCache/TMCache.h>
#import "CDResponseDTO.h"
#import "CDBaseAuthService.h"
#import <YYModel/YYModel.h>
#import "NSString+Addtion.h"
#import "ACAppConstant.h"
#define KSuccessCode @"0"

@interface CDAuthRequestQueue()

@property (nonatomic, strong) NSString *baseRequestUrl;
@property (nonatomic, copy) NSString *successCode;

@end


@implementation CDAuthRequestQueue

+(CDAuthRequestQueue *)sharedAuthRequestQueue{
    static CDAuthRequestQueue *sharedAuthRequestQueue;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^ {
        sharedAuthRequestQueue = [[CDAuthRequestQueue alloc] init];
    });
    
    return sharedAuthRequestQueue;
}

-(void)setBaseRequestUrl:(NSString *)baseRequestUrl{
    if (baseRequestUrl != nil) {
        _baseRequestUrl = baseRequestUrl;
    }
    [self initial];
}

-(void)initial{
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
#ifdef DEBUG
    if([self.baseRequestUrl containsString:@"https://"]){
        AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [policy setValidatesDomainName:NO];
        [policy setAllowInvalidCertificates:YES];
        self.securityPolicy = policy;
    }
#else
    //读取cer文件
//    [self supportSSLWithURL:[NSURL URLWithString:self.baseRequestUrl]];
    //读取cer转成的String
    [self supportSSLCerWithURL:[NSURL URLWithString:self.baseRequestUrl]];
    
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
        [self setSecurityPolicy:[self securityPolicyWithFileName:@"1"]];
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

   NSString *str2 = [NSString dataToBase64:certData];
    NSData *subData = [NSString base64ToData:str2];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    
    securityPolicy.validatesDomainName = YES;
    
    securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];
    
    return securityPolicy;
}

-(NSURLSessionTask *)startRequestOperationBase:(CDHttpReqestForAuth *)request success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed{
    if (request.requestDTO.successCode.length > 0) {
        self.successCode = request.requestDTO.successCode;
    } else {
        self.successCode = KSuccessCode;
    }
    
    NSMutableString *postMulStr = [[NSMutableString alloc] init];
    
    [request.requestDTO generateCommonParamDic];
    [request.requestDTO generateSign];
    
    [request.requestDTO.paramDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [postMulStr appendFormat:@"%@=%@&",[self urlencodedValue:key],[[obj class] isSubclassOfClass:[NSString class]] ? [self urlencodedValue:obj] : obj];
    }];
    
    NSMutableURLRequest *urlRequest;
    if (request.requestDTO.httpMethod == HttpMethodGet) {
        NSString *str = [NSString stringWithFormat:@"%@%@",self.baseRequestUrl,request.requestDTO.methodName];
        if (postMulStr.length > 0) {
            NSString *postStr = [postMulStr substringToIndex:[postMulStr length]-1];
            str = [NSString stringWithFormat:@"%@?%@",str,postStr];
        }
        urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kHttpTimeoutForAuth];
        urlRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [urlRequest setHTTPMethod:@"GET"];
        
    }else{
        urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.baseRequestUrl,request.requestDTO.methodName]]];
        [urlRequest setHTTPMethod:@"POST"];
        if (postMulStr.length>0) {
            NSString *postStr = [postMulStr substringToIndex:[postMulStr length]-1];
            [urlRequest setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        }
    }
    
    NSLog(@"method : %@ ; request : %@",request.requestDTO.methodName,request.requestDTO.paramDic);
    NSURLSessionTask *requestOperation;
    requestOperation = [self dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"登录失败 %@",error.localizedDescription);

            failed([CDHttpErrorCodeHandler errorWithCode:error.code userinfo:error.userInfo originError:nil]);
        } else {
            [self handleResponseDataForSuccess:((NSHTTPURLResponse *)response).statusCode response:response responseObject:responseObject authRequest:request success:success failed:failed];
        }
    }];
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    [requestOperation resume];
    return requestOperation;
}

-(NSURLSessionTask *)startRequestOperation:(CDHttpReqestForAuth *)request success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed{
    return [self startRequestOperationBase:request success:success failed:failed];
}

-(NSURLSessionTask *)startRequestOperationForMock:(CDHttpReqestForAuth *)request success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed{
    return [self startRequestOperationBase:request success:success failed:failed];
}

-(void)handleResponseDataForSuccess:(NSInteger)statusCode response:response  responseObject:(id)responseObject authRequest:(CDHttpReqestForAuth *)request success:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed{
     NSLog(@"requestMethodName === %@; responseObject === %@",request.requestDTO.methodName, responseObject);
    if(statusCode == 200){
        NSError *error = nil;
        CDResponseDTO *responseDTO = [CDResponseDTO yy_modelWithDictionary:responseObject];
        if(responseDTO.code != nil && [responseDTO.code intValue] != [self.successCode intValue]){
            if (responseDTO.data) {
                error = [NSError errorWithDomain:responseDTO.message?responseDTO.message:@"" code:[responseDTO.code intValue] userInfo:responseDTO.data];
            } else {
                error = [NSError errorWithDomain:responseDTO.message?responseDTO.message:@"" code:[responseDTO.code intValue] userInfo:responseDTO.result];
            }
            
            if ([responseDTO.code intValue] == 1003 || [responseDTO.code intValue] == 2200) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kForceLoginWithUserNamePwd object:nil];
                //登录失效，重新登录
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kRelogin object:nil];
                [CDBaseAuthService clearAuthWithoutLogin];
            } else if ([responseDTO.code intValue] == 10) {
                [[TMCache sharedCache] setObject:responseDTO.data[@"errorTime"] forKey:kLoginErrorNumbuer];
            } else if ([responseDTO.code intValue] == 12) {
                [[TMCache sharedCache] setObject:@"4" forKey:kLoginErrorNumbuer];
            }
            failed(error);
        }else{
            id result = nil;
            if (responseDTO.data) {
                result = [request.requestDTO getResponseByData:responseDTO.data error:error==nil?nil:error];
            } else {
                result = [request.requestDTO getResponseByData:responseDTO.result error:error==nil?nil:error];
            }
            success(result);
        }
    }else{
        failed([NSError errorWithDomain:@"服务器异常" code:statusCode userInfo:nil]);
    }
}

-(void)cancelAll{
    [self.operationQueue cancelAllOperations];
}

- (NSString*)urlencodedValue:(NSString *)value
{
    NSString* urlencodedString = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)value, NULL, CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return urlencodedString;
}


@end
