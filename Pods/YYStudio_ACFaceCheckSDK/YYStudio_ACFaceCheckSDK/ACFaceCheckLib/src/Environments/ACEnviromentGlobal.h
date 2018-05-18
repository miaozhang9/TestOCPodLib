//
//  ACEnviromentGlobal.h


#ifndef App_ACEnviromentGlobal_h
#define App_ACEnviromentGlobal_h

#import "SystemConfigure.h"
/* 网络框架环境
    0:prd  生产环境 - 可以用于发布的
    1:     测试环境 - 主环境
    2:     开发环境
   */

// 环境切换处在
//environment
//#define ENABLEGT //腾讯GT 性能监控
#define kCredooLoggerServer @"120.52.145.129"

#define kHttpURL            [[SystemConfigure shareSystemConfigure] get_kHttpURL]
#define kGtAppId        [[SystemConfigure shareSystemConfigure] get_kGtAppId]
#define kGtAppSecret     [[SystemConfigure shareSystemConfigure] get_kGtAppSecret]
#define kGtAppKey     [[SystemConfigure shareSystemConfigure] get_kGtAppKey]

#define kTalkingDataAppId     [[SystemConfigure shareSystemConfigure] get_kTalkingDataAppId]
#define kChannelID     [[SystemConfigure shareSystemConfigure] get_kChannelID]
#define kBuglyAppId     [[SystemConfigure shareSystemConfigure] get_kBuglyAppId]
#define kHttpSignPrefix     [[SystemConfigure shareSystemConfigure] get_kHttpSignPrefix]
#define kHttpSignSurfix     [[SystemConfigure shareSystemConfigure] get_kHttpSignSurfix]
#define kAnyChatIP  [[SystemConfigure shareSystemConfigure] get_kAnyChatIP]
#define kAnyChatPort    [[SystemConfigure shareSystemConfigure] get_kAnyChatPort]
#define kHtmlServiceURL [[SystemConfigure shareSystemConfigure] get_kHtmlServiceURL]
#define kHtmlAnyLoanConsultURL [[SystemConfigure shareSystemConfigure] get_kHtmlAnyLoanConsultURL]
#define kInternetSpeedTestURL [[SystemConfigure shareSystemConfigure] get_kInternetSpeedTestURL]

#endif





