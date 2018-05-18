//
//  userInfoCheck.m
//  AiCredit
//
//  Created by apple on 15/3/9.
//  Copyright (c) 2015年 tyf. All rights reserved.
//

#import "CredooUserInfoCheck.h"

@implementation CredooUserInfoCheck
/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(1)\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/*姓名验证USERNAME BY HELENSONG*/
+(BOOL) isValidataUserName:(NSString *)username{
    NSString * regex=@"[\u4e00-\u9fa5]{2,10}";
    NSPredicate * test=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([test evaluateWithObject:username]==YES)
    {
        for (int i=0; i<username.length; i++) {
            NSString * subStr=[username substringWithRange:NSMakeRange(i, 1)];
            NSString *userRegex = @"[\u4e00-\u9fa5]";
            NSPredicate *userTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userRegex];
            if ([userTest evaluateWithObject:subStr]==NO)
            {
                return NO;
            }
        }
        return YES;
    }
    else
    {
        return NO;
        
    }
}

/*密码验证 */
+(BOOL) isValidatePassword:(NSString *)password
{
    /* ~@!#$%^&*._%+- */
    NSString * passwordPegex=@"^^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate * passwordTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordPegex];
    return [passwordTest evaluateWithObject:password];
}

+(BOOL) isValidatePasswordWith:(NSString *)password min:(NSInteger)min max:(NSInteger)max{
    /* ~@!#$%^&*._%+- */
    NSString *passwordPegexFormat = @"^^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{%d,%d}$";
    NSString * passwordPegex=[NSString stringWithFormat:passwordPegexFormat,min,max];
    NSPredicate * passwordTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordPegex];
    return [passwordTest evaluateWithObject:password];
}



#pragma mark - 身份证识别
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    cardNo = [cardNo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    if (!cardNo) {
        return NO;
    }else {
        length = cardNo.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [cardNo substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15: {
            year = [cardNo substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:cardNo
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, cardNo.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            } else {
                return NO;
            }
        }
        case 18: {
            year = [cardNo substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:cardNo
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, cardNo.length)];
            
            if(numberofMatch >0) {
                int S = ([cardNo substringWithRange:NSMakeRange(0,1)].intValue + [cardNo substringWithRange:NSMakeRange(10,1)].intValue) *7 +
                ([cardNo substringWithRange:NSMakeRange(1,1)].intValue + [cardNo substringWithRange:NSMakeRange(11,1)].intValue) *9 +
                ([cardNo substringWithRange:NSMakeRange(2,1)].intValue + [cardNo substringWithRange:NSMakeRange(12,1)].intValue) *10 +
                ([cardNo substringWithRange:NSMakeRange(3,1)].intValue + [cardNo substringWithRange:NSMakeRange(13,1)].intValue) *5 +
                ([cardNo substringWithRange:NSMakeRange(4,1)].intValue + [cardNo substringWithRange:NSMakeRange(14,1)].intValue) *8 +
                ([cardNo substringWithRange:NSMakeRange(5,1)].intValue + [cardNo substringWithRange:NSMakeRange(15,1)].intValue) *4 +
                ([cardNo substringWithRange:NSMakeRange(6,1)].intValue + [cardNo substringWithRange:NSMakeRange(16,1)].intValue) *2 +
                [cardNo substringWithRange:NSMakeRange(7,1)].intValue *1 +
                [cardNo substringWithRange:NSMakeRange(8,1)].intValue *6 +
                [cardNo substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[cardNo substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        }
        default:
            return false;
    }
    return false;
}


//检测验证码是否合格
+(BOOL) isValidVerifyCode:(NSString *)code {
    NSString * passwordPegex=@"^[0-9]{4,8}$";
    NSPredicate * passwordTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordPegex];
    return [passwordTest evaluateWithObject:code];
}

//是否为有效的支付密码
+(BOOL) isValidatePaymentPwd:(NSString *)paymentPwd
{
    NSString * passwordPegex=@"^[0-9]{6}$";
    NSPredicate * passwordTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordPegex];
    return [passwordTest evaluateWithObject:paymentPwd];
}

//银行卡校验
+(BOOL) isValidIDCard:(NSString *)cardNo
{
//    方案1
    NSInteger oddsum = 0;     //奇数求和
    NSInteger evensum = 0;    //偶数求和
    NSInteger allsum = 0;
    NSInteger cardNoLength = (NSInteger)[cardNo length];
    NSInteger lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength -1];
    for (NSInteger i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1,1)];
        NSInteger tmpVal = [tmpString integerValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) ==0)
        return YES;
    else
        return NO;
    
    
//   方案2
//        if(cardNo.length==0)
//            
//        {
//            
//            return NO;
//            
//        }
//        
//        NSString *digitsOnly = @"";
//        
//        char c;
//        
//        for (int i = 0; i < cardNo.length; i++)
//            
//        {
//            
//            c = [cardNo characterAtIndex:i];
//            
//            if (isdigit(c))
//                
//            {
//                
//                digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
//                
//            }
//            
//        }
//        
//        int sum = 0;
//        
//        int digit = 0;
//        
//        int addend = 0;
//        
//        BOOL timesTwo = false;
//        
//        for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
//            
//        {
//            
//            digit = [digitsOnly characterAtIndex:i] - '0';
//            
//            if (timesTwo)
//                
//            {
//                
//                addend = digit * 2;
//                
//                if (addend > 9) {
//                    
//                    addend -= 9;
//                    
//                }
//                
//            }
//            
//            else {
//                
//                addend = digit;
//                
//            }
//            
//            sum += addend;
//            
//            timesTwo = !timesTwo;
//            
//        }
//        
//        int modulus = sum % 10;
//        
//        return modulus == 0;
//        
  
//    NSString * cardPegex=@"^\\d{1,}$";
//     NSString * cardPegex=@"^[1-9][0-9]{5,31}$";
//    NSPredicate * cardTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",cardPegex];
//    return [cardTest evaluateWithObject:cardNo];
//    if ([cardNo isEqualToString:@""]||[cardNo isEqual:[NSNull null]]) {
//        return NO;
//    }
//    return YES;
}


+(CredooUserInfoCheck *)sharedInstance
{
    static CredooUserInfoCheck *instance = nil;
    static dispatch_once_t globaldata;
    
    dispatch_once(&globaldata, ^{
        instance = [[super alloc] init];
    });
    return instance;
}


+ (void)addObserverUsingBlock:(YTHandlerEnterBackgroundBlock)block {
    __block CFAbsoluteTime enterBackgroundTime;
    [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (![note.object isKindOfClass:[UIApplication class]]) {
            enterBackgroundTime = CFAbsoluteTimeGetCurrent();
        }
    }];
    __block CFAbsoluteTime enterForegroundTime;
    [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (![note.object isKindOfClass:[UIApplication class]]) {
            enterForegroundTime = CFAbsoluteTimeGetCurrent();
            CFAbsoluteTime timeInterval = enterForegroundTime-enterBackgroundTime;
            
            block? block(note, timeInterval): nil;
        }
    }];
}

+ (void)removeNotificationObserver:(id)observer {
    if (!observer) {
        return;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:observer name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:observer name:UIApplicationWillEnterForegroundNotification object:nil];
}

@end
