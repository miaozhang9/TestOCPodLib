//
//  NSString+Addtion.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/5/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "NSString+Addtion.h"

@implementation NSString (Addtion)

// 格式化千分位数字：如32115900 ==> 32,115,900
+ (NSString *)pc_formatThousandsStringWithString:(NSString *)doubleStr
{
    if ([doubleStr isKindOfClass:[NSNumber class]]) {
        doubleStr = [(NSNumber *)doubleStr stringValue];
    }
    if (![doubleStr isKindOfClass:[NSString class]]) {
        doubleStr = @"0";
    }
    
    doubleStr = [doubleStr stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSMutableString *resultStr  = [@"0" mutableCopy];
    NSString *_firstChar        = @"";
    
    if (doubleStr && [doubleStr isKindOfClass:[NSString class]] && doubleStr.length > 0)
    {
        _firstChar        = [doubleStr substringToIndex:1];
        if ([_firstChar isEqualToString:@"+"] || [_firstChar isEqualToString:@"-"]) {
            doubleStr = [doubleStr substringWithRange:NSMakeRange(1, doubleStr.length - 1)];
        }
        else
        {
            _firstChar        = @"";
        }
        resultStr = [NSMutableString stringWithString:doubleStr];
        
        NSInteger dotLoc = -1;
        for (NSInteger i = 0; i < [doubleStr length]; i ++ ){
            char ch = [doubleStr characterAtIndex:i];
            if (ch == '.') {
                dotLoc = i;
                break;
            }
        }
        
        NSString *str;
        if (dotLoc == -1) {
            str = doubleStr;
        }
        else {
            str = [doubleStr substringWithRange:NSMakeRange(0, dotLoc)];
        }
        if ([str length] > 3) {
            NSInteger remainderNum = [str length]%3; // 余数
            NSInteger divisor = [str length]/3-1; // 除数
            if (remainderNum) {
                [resultStr insertString:@"," atIndex:remainderNum];
            }
            for (NSInteger i = 0; i < divisor; i ++) {
                if (remainderNum) {
                    [resultStr insertString:@"," atIndex:remainderNum+3*(i+1)+i+1];
                } else {
                    [resultStr insertString:@"," atIndex:remainderNum+3*(i+1)+i];
                }
            }
        }
        
    }
    
    resultStr = [[_firstChar stringByAppendingString:resultStr] mutableCopy];
    return resultStr;
}

+ (NSString *)pc_formatThousandsStringWithString:(NSString *)string decimal:(int)decimal
{
    if ([string isKindOfClass:[NSNumber class]]) {
        string = [(NSNumber *)string stringValue];
    }
    if (![string isKindOfClass:[NSString class]]) {
        string = @"0";
    }
    string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *format = [NSString stringWithFormat:@"%%.%df", decimal];
    return [self pc_formatThousandsStringWithString:[NSString stringWithFormat:format, string.doubleValue]];
}

+ (NSString *)pc_formatThousandsMoneyString:(NSString *)string
{
    return [self pc_formatThousandsStringWithString:string decimal:2];
}

// 获取字符串的长度
- (CGSize)pc_sizeForStringWithSize:(CGSize)size fontSize:(CGFloat)font{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
}

- (CGSize)pc_sizeForStringWithSize:(CGSize)size font:(UIFont *)font{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

// 将字符串转化为字符数组
+ (NSArray *)charArrayFromString:(NSString *)str {
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i < str.length; i++ ) {
        [marr addObject:[str substringWithRange:NSMakeRange(i, 1)]];
    }
    return [marr copy];
}

- (NSString *)pc_stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)pc_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

-(NSData *)dataFromHexString {
    const char *chars = [self UTF8String];
    NSUInteger i = 0, len = self.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

+(NSData*)hexStringToByte:(NSString*)hexString
{
//    hexString=[[hexString uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ([hexString length]%2!=0)
//    {
//        return nil;
//    }
    
    Byte tmpByt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i = 0; i < [hexString length]; i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; //两位 16 进制数中的第一位（高位*16 ）
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16; //0 的 Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //A 的 Ascll - 65
        else
            return nil;
        
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; //两位 16 进制数中的第二位（低位）
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //0 的 Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //A 的 Ascll - 65
        else
            return nil;
        
        tmpByt[0] = int_ch1+int_ch2; ///将转化后的数放入 Byte 数组里
        [bytes appendBytes:tmpByt length:1];
    }
    return bytes;
}
+ (NSString *)dataToBase64:(NSData *)data{
    
    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return str;
}

+ (NSData *)base64ToData:(NSString *)str{
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

@end
