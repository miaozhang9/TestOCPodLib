//
//  CredooApiFramework.m
//  CredooApiFramework
//
//  Created by 徐佳良 on 16/11/2.
//  Copyright © 2016年 Credoo. All rights reserved.
//

#import "CredooApiFramework.h"

@implementation CredooApiFramework

+(CredooApiFramework *)sharedInstance{
    static CredooApiFramework *sharedCredooApiFrameworkQueue;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^ {
        sharedCredooApiFrameworkQueue = [[CredooApiFramework alloc] init];
    });
    
    return sharedCredooApiFrameworkQueue;
}


-(void)setHttpBaseUrl:(NSArray *)baseUrls withSignPrefix:(NSString *)prefix withHttpSignSurfix:(NSString *)surfix {
    self.httpRequestUrls = baseUrls;
    self.httpSignPrefix = prefix;
    self.httpSignSurfix = surfix;
}

@end
