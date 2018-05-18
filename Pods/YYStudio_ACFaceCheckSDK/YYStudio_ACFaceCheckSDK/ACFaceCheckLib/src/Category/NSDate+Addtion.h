//
//  NSDate+Addtion.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/5/22.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addtion)

// 判断当前是上午还是下午
+ (NSString *)currentDateForAMSymbolOrPMSymbol;

// 获取当前时间的年月日时分秒
+ (NSDictionary *)currentDateForMonthYearDay;

// NSTimeInterval 转化为 hh:mm
+ (NSString *)hourAndMinuteFromTimeInterval:(NSString *)timeIntervalStr;
//HH:mm
+ (NSString *)dateFormatterTimeNomalWithTime:(NSString *)time;
//获取当前时间 HH:mm:ss
+ (NSString *)dateFormatterWithCurrentPreciseTime;
//YYYY年MM月dd日HH:mm
+ (NSString *)dateFormatterDayNomalWithTime:(NSString *)time;
//传入时间戳转化为全格式 MM-dd HH:mm:ss
+ (NSString *)dateFormatterWithTime:(NSString *)time;
//获取当前时间 YYYY-MM-dd HH:mm:ss
+ (NSString *)dateFormatterWithCurrentTime;
//传入时间戳转化为特定格式 YYYY-MM-dd
+ (NSString *)onlydateFormatterWithTime:(NSString *)time;
//传入时间戳转化为特定格式 MM-dd
+ (NSString *)onlyDayFormatterWithTime:(NSString *)time;
//传入特定格式 YYYY-MM-dd 转化为时间戳
+ (NSString *)onlydateFormatterToLongWithTime:(NSString *)time;
// 判断一个日期是否是今天
+ (BOOL)isTodayWithTime:(NSString *)timeInterval;
// 判断一个日期是否是明天
+ (BOOL)isTomorrowWithTime:(NSString *)timeInterval;
// 判断一个日期是否是后天
+ (BOOL)isAfterTomorrowWithTime:(NSString *)timeInterval ;
//时间戳转换成星期
+(NSString *)weekStringFromTime:(NSString *)timeInterval;
@end
