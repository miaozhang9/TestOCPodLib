//
//  UIDevice+Credoo.h
//  CredooApiFramework
//
//  Created by 郭阳阳(金融壹账通客户端研发团队) on 2018/2/5.
//  Copyright © 2018年 郭阳阳(金融壹账通客户端研发团队). All rights reserved.
//

#import <UIKit/UIKit.h>

#include <sys/socket.h>
#include <sys/sysctl.h>

@interface UIDevice (Credoo)

- (NSString *)credoo_machineModel;
+ (double)credoo_systemVersion;

@end


@interface NSString (Credoo)

- (NSString *)credoo_md5String;

@end
