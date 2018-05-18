//
//  NSDate+Addtion.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/5/22.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "NSDate+Addtion.h"
// YYYY-MM-dd yyyy-MM-dd HH:mm:ss
@implementation NSDate (Addtion)

// 判断当前是上午还是下午
+ (NSString *)currentDateForAMSymbolOrPMSymbol {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.AMSymbol = @"上午";
    format.PMSymbol = @"下午";
    format.dateFormat = @"aaa";
    return [format stringFromDate:[NSDate date]];
}

+ (NSDictionary *)currentDateForMonthYearDay {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSString *year = [NSString stringWithFormat:@"%ld",[dateComponent year]];
    NSString *month = [NSString stringWithFormat:@"%ld",[dateComponent month]];
    NSString *day = [NSString stringWithFormat:@"%ld",[dateComponent day]];
    NSString *hour = [NSString stringWithFormat:@"%ld",[dateComponent hour]];
    NSString *minute = [NSString stringWithFormat:@"%ld",[dateComponent minute]];
    NSString *second = [NSString stringWithFormat:@"%ld",[dateComponent second]];
    NSDictionary *dic = @{@"year":year, @"month":month, @"day":day,@"hour":hour,@"minute":minute,@"second":second};
    return dic;
}
+ (NSString *)dateFormatterDayNomalWithTime:(NSString *)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000] ;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日HH:mm"];
    return [formatter stringFromDate:date];
}
+ (NSString *)dateFormatterTimeNomalWithTime:(NSString *)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000] ;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:date];
}
+ (NSString *)dateFormatterWithCurrentPreciseTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm:ss"];
    return [formatter stringFromDate:date];
}
+ (NSString *)dateFormatterWithTime:(NSString *)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000] ;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

+ (NSString *)dateFormatterWithCurrentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

+ (NSString *)onlydateFormatterWithTime:(NSString *)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000] ;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return [formatter stringFromDate:date];
}

+ (NSString *)onlyDayFormatterWithTime:(NSString *)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000] ;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd"];
    return [formatter stringFromDate:date];
}

+ (NSString *)onlydateFormatterToLongWithTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate* date = [formatter dateFromString:time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000];
    return timeSp;
}

+ (NSString *)hourAndMinuteFromTimeInterval:(NSString *)timeIntervalStr {
    NSTimeInterval timeInterval = [timeIntervalStr doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm"];
    NSArray *arr = [[dateFormatter stringFromDate:date] componentsSeparatedByString:@" "];
    return [arr lastObject];
}

+ (BOOL)isTodayWithTime:(NSString *)timeInterval {
    NSTimeInterval interval = [timeInterval doubleValue]/1000;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *inputDate = [formatter stringFromDate:newDate];
    NSDate *today = [[NSDate alloc] init];
    NSString *todayString = [formatter stringFromDate:today];
    if ([inputDate isEqualToString:todayString]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isTomorrowWithTime:(NSString *)timeInterval {
    
    NSTimeInterval interval = [timeInterval doubleValue]/1000;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *inputDate = [formatter stringFromDate:newDate];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow= [today dateByAddingTimeInterval: secondsPerDay];
    NSString *tomorrowString = [formatter stringFromDate:tomorrow];
    
    if ([inputDate isEqualToString:tomorrowString]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isAfterTomorrowWithTime:(NSString *)timeInterval {
    
    NSTimeInterval interval = [timeInterval doubleValue]/1000;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *inputDate = [formatter stringFromDate:newDate];
    NSTimeInterval secondsPerDay = 2 * 24 * 60 * 60;
    
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow= [today dateByAddingTimeInterval: secondsPerDay];
    NSString *tomorrowString = [formatter stringFromDate:tomorrow];
    
    if ([inputDate isEqualToString:tomorrowString]) {
        return YES;
    } else {
        return NO;
    }
}

+(NSString *)weekStringFromTime:(NSString *)timeInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]/1000] ;
    NSArray *weeks=@[[NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone=[[NSTimeZone alloc]initWithName:@"Asia/Beijing"];
    [calendar setTimeZone:timeZone];
    NSCalendarUnit calendarUnit=NSCalendarUnitWeekday;
    NSDateComponents *components=[calendar components:calendarUnit fromDate:date];
    return [weeks objectAtIndex:components.weekday];
}


@end
