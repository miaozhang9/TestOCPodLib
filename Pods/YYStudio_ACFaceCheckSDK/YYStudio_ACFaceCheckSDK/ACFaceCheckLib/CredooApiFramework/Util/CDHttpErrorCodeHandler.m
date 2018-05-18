//
//  HttpErrorCodeHandler.m
//  CredooDSD
//
//  Created by xujialiang on 15/12/7.
//  Copyright © 2015年 credoo. All rights reserved.
//

#import "CDHttpErrorCodeHandler.h"

@implementation CDHttpErrorCodeHandler

+(NSError *)errorWithCode:(NSInteger)code userinfo:(NSDictionary *)userinfo originError:(NSError *)error{
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    NSString *codePath = [mainBundle.bundlePath stringByAppendingString:@"/HttpErrorCodeDictionary.plist"];
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:codePath];
//    NSString *codeidstr = [NSString stringWithFormat:@"%ld",(long)code];
//    NSString *errStr = [dic objectForKey:codeidstr];
//    //先查字典表，没有的话，取服务器返回的值
//    if (errStr == nil) {
//        if (error.domain!=nil && ![error.domain isEqualToString:@""]) {
//            errStr = error.domain;
//        }else{
//            errStr = @"无法连接到服务器";
//        }
//
//        NSLog(@"code : %@, 无法连接到服务器", codeidstr);
//    }
//
    NSString *errStr = nil;
     //先取服务器返回的值，没有的话，再查字典表
    if(error.domain!=nil && ![error.domain isEqualToString:@""]){
          errStr = error.domain;
    } else {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *codePath = [mainBundle.bundlePath stringByAppendingString:@"/HttpErrorCodeDictionary.plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:codePath];
        NSString *codeidstr = [NSString stringWithFormat:@"%ld",(long)code];
        NSString *tmperrStr = [dic objectForKey:codeidstr];
        if (tmperrStr!=nil && ![tmperrStr isEqualToString:@""]) {
            errStr = tmperrStr;
        }else {
             errStr = @"无法连接到服务器";
        }
    }
    
    NSError *err = [NSError errorWithDomain:errStr code:code userInfo:userinfo];
    
    return err;
}

@end
