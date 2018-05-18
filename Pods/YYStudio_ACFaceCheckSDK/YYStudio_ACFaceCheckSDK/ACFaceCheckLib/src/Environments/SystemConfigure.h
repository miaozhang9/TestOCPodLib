//
//  SystemConfigure.h
//  PersonalCenter
//
//  Created by Miaoz on 2017/5/17.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PCEnvironment) {
    Prod    = 0,
    Stage          = 1,
    Development,
    EnvironmentNone = 10000,
};

@interface SystemConfigure : NSObject

+ (SystemConfigure *)shareSystemConfigure;

-(void)resetEnvironment;

// 代码切换测试生产环境
- (void)set_Environment:(NSString *)wantEnvironment;

- (NSString *)get_EnvironmentStr;

- (PCEnvironment)get_Environment;

- (BOOL)isProductionEnvironment;
- (NSString *)get_currentEnvironmentStr;

-(NSString*)get_kHttpURL;
-(NSString *)get_kGtAppId;
-(NSString *)get_kGtAppSecret;
-(NSString *)get_kGtAppKey;
-(NSString *)get_kTalkingDataAppId;
-(NSString *)get_kChannelID;
-(NSString *)get_kBuglyAppId;
-(NSString *)get_kHttpSignPrefix;
-(NSString *)get_kHttpSignSurfix;
-(NSString *)get_kHtmlServiceURL;
-(NSString *)get_kAnyChatIP;
-(NSString *)get_kAnyChatPort;
-(NSString *)get_kHtmlAnyLoanConsultURL;
-(NSString *)get_kInternetSpeedTestURL;

@end
