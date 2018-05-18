//
//  HttpErrorCodeHandler.h
//  CredooDSD
//
//  Created by xujialiang on 15/12/7.
//  Copyright © 2015年 credoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDHttpErrorCodeHandler : NSObject

+(NSError *)errorWithCode:(NSInteger)code userinfo:(NSDictionary *)userinfo originError:(NSError *)error;

@end
