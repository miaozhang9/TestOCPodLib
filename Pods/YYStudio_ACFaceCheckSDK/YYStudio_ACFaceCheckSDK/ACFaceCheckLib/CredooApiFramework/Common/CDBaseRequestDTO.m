//
//  BaseRequestForAuth.m
//  DataYesDrJ
//
//  Created by jia.wang on 14/11/27.
//  Copyright (c) 2014年 jia.wang. All rights reserved.
//

#import "CDBaseRequestDTO.h"
#import "CDHttpErrorCodeHandler.h"
#import <CommonCrypto/CommonDigest.h>
#import <FCUUID/FCUUID.h>
#import "CredooApiFramework.h"
#import "CredooApiFrameworkConst.h"
#import <TMCache/TMCache.h>
#import "UIDevice+Credoo.h"

@implementation CDBaseRequestDTO
@synthesize paramDic,methodName;

-(id)init{
    if(self = [super init]){
        self.paramDic = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)generateCommonParamDic{
    [self.paramDic setObject:[FCUUID uuidForDevice] forKey:@"deviceId"];
    [self.paramDic setObject:@"iOS" forKey:@"os"];
    [self.paramDic setObject:[[UIDevice new] credoo_machineModel] forKey:@"deviceName"];
    [self.paramDic setObject:[NSString stringWithFormat:@"%f",[UIDevice credoo_systemVersion]] forKey:@"osVersion"];
    [self.paramDic setObject:[NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]] forKey:@"appVersion"];
    [self.paramDic setObject:@"anyloan" forKey:@"channel"];
    NSString *token = [[TMCache sharedCache] objectForKey:@"LoginTokenKey"];
    
    if (token) {
        if (self.securityType == SecurityType_UserMustLogin) {
            [self.paramDic setObject:token forKey:@"loginToken"];
            [self.paramDic setObject:token forKey:@"token"];
        }
    }
}

-(void)generateParamDic:(NSDictionary *)param{
    [self.paramDic addEntriesFromDictionary:param];
}

-(void)generateSign{
    NSString *sortStr = [self sortDic:self.paramDic];
    NSString *signStr = [self getSign:sortStr];
    
    [self.paramDic setObject:signStr forKey:@"sign"];
}

-(void)generateUploadSign{
    NSString *sortStr = [self sortDic:self.paramDic];
    NSString *signStr = [self getSign:sortStr];
    
    [self.paramDic setObject:signStr forKey:@"sign"];
}

-(id)getResponseByData:(id)dataDic error:(NSError **)error {
    if (error!=NULL) {
        if ([dataDic isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[dataDic objectForKey:@"code"] integerValue];
            *error = [CDHttpErrorCodeHandler errorWithCode:code userinfo:nil originError:nil];
        }
    }
    return nil;
}


-(NSString *)sortDic:(NSDictionary *)postDic{
    NSArray * keys = [postDic allKeys];
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        return [obj1 compare:obj2];
    };
    NSArray * allKeys = [keys sortedArrayUsingComparator:sort];
    
    NSString * sortDicString = @"";
    
    for (id ikey in allKeys) {
        NSString * value = [postDic objectForKey:ikey];
        
        sortDicString = [NSString stringWithFormat:@"%@&%@=%@",sortDicString, ikey, value];
    }
    return [sortDicString substringFromIndex:1];
}

-(NSString *)getSign:(NSString *)dic{
    NSString * prefix = [CredooApiFramework sharedInstance].httpSignPrefix;
    NSString * suffix = [CredooApiFramework sharedInstance].httpSignSurfix;
    NSString * signString = [NSString stringWithFormat:@"%@%@%@", prefix, dic, suffix];
    return signString.credoo_md5String;
}

-(void)dealloc{
    NSLog(@"====%@ is dealloc=====",[[self class] description]);
}

@end
