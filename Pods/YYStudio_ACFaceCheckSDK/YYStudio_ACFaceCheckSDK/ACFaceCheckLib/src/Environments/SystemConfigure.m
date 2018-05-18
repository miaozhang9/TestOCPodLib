//
//  SystemConfigure.m
//  PersonalCenter
//
//  Created by Miaoz on 2017/5/17.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "SystemConfigure.h"
#import "ACEnviromentGlobal.h"
#import "ACFaceCheckHelper.h"
@interface SystemConfigure()

@property(nonatomic, strong)NSMutableDictionary *enviromentDic;
@property(nonatomic, assign)PCEnvironment environment;

@end

@implementation SystemConfigure


/* 网络框架环境
 0:prd  生产环境 - 可以用于发布的
 1:     测试环境 - 主环境
 2:     测试环境 - 用于信用卡，超级网银模块
 3:     Appstore生产环境，用于发布到Appstore
 */

// 环境切换处在 environment plist 文件中

+(SystemConfigure *)shareSystemConfigure
{
    static SystemConfigure* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SystemConfigure alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _environment = EnvironmentNone;
        [self resetEnvironment];
    }
    return self;
}

- (void)setEnvironment:(PCEnvironment)environment
{
    if (_environment == environment)
    {
        return;
    }
    
    if (EnvironmentNone == _environment)
    {
        _environment = Prod;
    }
    
    _environment = environment;
}




//- (NSString *)getDebugEnvironment
//{
//    NSString *envPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), @"DebugEnvironment.txt"];
//    NSLog(@"%@", envPath);
//    NSString *str = [NSString stringWithContentsOfFile:envPath encoding:NSUTF8StringEncoding error:nil];
//    return str;
//}

-(void)resetEnvironment
{
    //    NSString *environmentStr = [self getDebugEnvironment];
    //
    //

    NSString *enviromentPath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"enviroment.plist"] ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:enviromentPath];
    NSString * environmentStr = dic[@"Environment"];

     if (environmentStr) {
        self.environment = [self convertFromStrEnvironment:environmentStr];
        //其实没啥用  jenkins打包时才用
        [self getEnvironmentDic:environmentStr];
     } else {
              _environment = EnvironmentNone;
     }
    
}

-(void)getEnvironmentDic:(NSString*)environmentStr
{
    NSString *subPath = [[NSBundle bundleForClass:[self class]]pathForResource:environmentStr ofType:@"plist"];
    _enviromentDic = [[NSMutableDictionary alloc] initWithContentsOfFile:subPath];
}


- (NSString *)yzt_fetchEnvironmentStr
{
    if(self.environment)
    {
        return [self get_EnvironmentStr];
    }
    else
    {
        NSString *path=[[NSBundle bundleForClass:[self class]]pathForResource:@"enviroment" ofType:@"plist"];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
        NSString *environmentStr = dic[@"Environment"];
        return environmentStr;
    }
}

- (NSString *)get_currentEnvironmentStr
{
    return [self yzt_fetchEnvironmentStr];
}

-(NSString *)get_EnvironmentStr
{
    return [self convertToEnvironmentStr:self.environment];
}

-(PCEnvironment)get_Environment
{
    return self.environment;
}

-(BOOL)isProductionEnvironment
{
    if(self.environment == Prod )
    {
        return YES;
    }
    else{
        return NO;
    }
}

- (PCEnvironment)convertFromStrEnvironment:(NSString*)environmentStr {
    if([environmentStr isEqualToString:@"Prod"])
    {
        return Prod;
    }
    else if([environmentStr isEqualToString:@"Stage"])
    {
        return Stage;
    }
    else if([environmentStr isEqualToString:@"Development"])
    {
        return Development;
    }
    else{
        return Prod;
    }
}


//数字环境转英文文本对应环境
- (NSString *)convertToEnvironmentStr:(PCEnvironment)environment {
    switch (environment) {
        case Prod:
            return @"Prod";
            break;
            
        case Stage:
            return @"Stage";
            break;
            
        case Development:
            return @"Development";
            break;
            
        case EnvironmentNone:
            return @"None";
            break;
    }
}



-(NSString*)get_kHttpURL
{
    
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            
            return @"https://qhcs-qjj-stg2.credoo.com.cn:51143";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"https://qhcs-qjj.credoo.com.cn";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"https://qhcs-qjj-stg.credoo.com.cn:33443";
            break;
        default:
              return @"https://qhcs-qjj.credoo.com.cn";
            break;
    }
  

//    return self.enviromentDic[@"kHttpURL"];
    
    
}

-(NSString *)get_kGtAppId
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
             return @"ec1CNpkHqu8mxuT60htqIA";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"ec1CNpkHqu8mxuT60htqIA";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"ec1CNpkHqu8mxuT60htqIA";
            break;
        default:
              return @"ec1CNpkHqu8mxuT60htqIA";
            break;
    }
//    return self.enviromentDic[@"kGtAppId"];
    
}

-(NSString *)get_kGtAppSecret
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            return @"qLFaajg0Un8PDXgMgVx6w4";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"qLFaajg0Un8PDXgMgVx6w4";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"qLFaajg0Un8PDXgMgVx6w4";
            break;
        default:
             return @"qLFaajg0Un8PDXgMgVx6w4";
            break;
    }
//    return self.enviromentDic[@"kGtAppSecret"];
    
}

-(NSString *)get_kGtAppKey
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            return @"wRq8fkfc0X7uqmiHoJ0nM1";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"wRq8fkfc0X7uqmiHoJ0nM1";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"wRq8fkfc0X7uqmiHoJ0nM1";
            break;
        default:
             return @"wRq8fkfc0X7uqmiHoJ0nM1";
            break;
    }
//    return self.enviromentDic[@"kGtAppKey"];
}

-(NSString *)get_kTalkingDataAppId
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            return @"C805CB2AD54E452A869A8D5F2E27164A";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"C805CB2AD54E452A869A8D5F2E27164A";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"C805CB2AD54E452A869A8D5F2E27164A";
            break;
        default:
            return @"C805CB2AD54E452A869A8D5F2E27164A";
            break;
    }
//    return self.enviromentDic[@"kTalkingDataAppId"];
}

-(NSString *)get_kChannelID
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            return @"10168";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"10168";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"10168";
            break;
        default:
             return @"10168";
            break;
    }
//    return self.enviromentDic[@"kChannelID"];
}

-(NSString *)get_kBuglyAppId
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            return @"e8fb333539";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"e8fb333539";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"e8fb333539";
            break;
        default:
             return @"e8fb333539";
            break;
    }
//    return self.enviromentDic[@"kBuglyAppId"];
}
-(NSString *)get_kHttpSignSurfix
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            return @"_6593fad01b14b85edf79051a9edc168d";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"_8d8b23d8a97b9547cf41d7fe6d8f3e07";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"_6593fad01b14b85edf79051a9edc168d";
            break;
        default:
             return @"_8d8b23d8a97b9547cf41d7fe6d8f3e07";
            break;
    }
//    return self.enviromentDic[@"kHttpSignSurfix"];
}

-(NSString *)get_kHttpSignPrefix
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
              return @"2CAPP_";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"2CAPP_";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"2CAPP_";
            break;
        default:
             return @"2CAPP_";
            break;
    }
// return self.enviromentDic[@"kHttpSignPrefix"];
}
-(NSString *)get_kHtmlServiceURL
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            return @"https://p2pp-loan-stg2.pingan.com.cn:33443/loan/page/tocapporderlist/index.html?t=contract";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"https://rmgs.pingan.com/loan/page/tocapporderlist/index.html?t=contract";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"https://p2pp-loan-stg2.pingan.com.cn:33443/loan/page/tocapporderlist/index.html?t=contract";
            break;
        default:
             return @"https://rmgs.pingan.com/loan/page/tocapporderlist/index.html?t=contract";
            break;
    }
//    return self.enviromentDic[@"kHtmlServiceURL"];
}
-(NSString *)get_kAnyChatIP
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            return @"172.18.2.204";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"chat.24money.com";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"172.18.2.204";
            break;
        default:
             return @"chat.24money.com";
            break;
    }
//    return self.enviromentDic[@"kAnyChatIP"];
}

-(NSString *)get_kAnyChatPort
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            return @"8912";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"4789";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"8912";
            break;
        default:
             return @"4789";
            break;
    }
//    return self.enviromentDic[@"kAnyChatPort"];
}
-(NSString *)get_kHtmlAnyLoanConsultURL
{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            return @"https://p2pp-loan-stg2.pingan.com.cn:33443/loan/page/tocapporderlist/index.html?t=info";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"https://rmgs.pingan.com/loan/page/tocapporderlist/index.html?t=info";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"https://test-p2pp-loan-stg.pingan.com.cn/loan/page/tocapporderlist/index.html?t=info";
            break;
        default:
             return @"https://rmgs.pingan.com/loan/page/tocapporderlist/index.html?t=info";
            break;
    }
//    return self.enviromentDic[@"kHtmlAnyLoanConsultURL"];
}

-(NSString *)get_kInternetSpeedTestURL{
    switch ([ACFaceCheckHelper share].environment) {
        case ACFaceCheckEnvironment_stg:
            return @"https://qhcs-qjj-stg.credoo.com.cn:33443/qjj_app/website/anychatq/img/bg.png";
            break;
        case ACFaceCheckEnvironment_prd:
            return @"http://chat.24money.com/q/img/bg.png";
            break;
        case ACFaceCheckEnvironment_dev:
            return @"https://qhcs-qjj-stg.credoo.com.cn:33443/qjj_app/website/anychatq/img/bg.png";
            break;
        default:
             return @"http://chat.24money.com/q/img/bg.png";
            break;
    }
//    return self.enviromentDic[@"kInternetSpeedTestURL"];
}

@end
