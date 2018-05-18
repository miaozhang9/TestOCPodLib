//
//  UIDevice+Credoo.m
//  CredooApiFramework
//
//  Created by 郭阳阳(金融壹账通客户端研发团队) on 2018/2/5.
//  Copyright © 2018年 郭阳阳(金融壹账通客户端研发团队). All rights reserved.
//

#import "UIDevice+Credoo.h"

#import <CommonCrypto/CommonDigest.h>

@implementation UIDevice (Credoo)

- (NSString *)credoo_machineModel{
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

+ (double)credoo_systemVersion{
    static double version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return version;
}

@end


@implementation NSString (Credoo)

- (NSString *)credoo_md5String {
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int) strlen(cStr), result);
    NSString *md5String = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5String;
}
@end
