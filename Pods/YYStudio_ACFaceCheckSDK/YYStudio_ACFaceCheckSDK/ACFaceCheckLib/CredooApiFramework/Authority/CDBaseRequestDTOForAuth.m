//
//  BaseRequestForAuth.m
//  DataYesDrJ
//
//  Created by jia.wang on 14/11/27.
//  Copyright (c) 2014年 jia.wang. All rights reserved.
//

#import "CDBaseRequestDTOForAuth.h"
#import "CDHttpErrorCodeHandler.h"
#import <CommonCrypto/CommonDigest.h>
#import <FCUUID/FCUUID.h>
#import "CredooApiFramework.h"
#import <TMCache/TMCache.h>
#import "UIDevice+Credoo.h"

@implementation CDBaseRequestDTOForAuth
@synthesize paramDic,methodName,httpMethod;

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
        if (self.isMustLogin) {
            [self.paramDic setObject:token forKey:@"loginToken"];
            [self.paramDic setObject:token forKey:@"token"];
        }
    }
}
+ (NSString *)machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}


-(void)generateParamDic:(NSDictionary *)param{
    [self.paramDic addEntriesFromDictionary:param];
}

-(void)generateSign{
    NSString *sortStr = [self sortDic:self.paramDic];
    NSString *signStr = [self getSign:sortStr];
    [self.paramDic setObject:signStr forKey:@"sign"];
}

-(id)getResponseByData:(NSDictionary *)dataDic error:(NSError *)error{
    
    return nil;
}

-(NSString*)md5Hash:(NSString *)string{
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (unsigned int)[data length], result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
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
    if (_otherHttpSignPrefix.length > 0 && _otherHttpSignSurfix.length > 0) {
        prefix = _otherHttpSignPrefix;
        suffix = _otherHttpSignSurfix;
    }
    NSString * signString = [NSString stringWithFormat:@"%@%@%@", prefix, dic, suffix];
    return [self md5Hash:signString];
}

@end
