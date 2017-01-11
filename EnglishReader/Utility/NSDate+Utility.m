//
//  NSDate+Utility.m
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

//获取当前系统时间
+ (NSDate *)currentDate {
    NSDate *date = [NSDate date]; // 获得时间对象
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    NSDate *dateNow = [date dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
    
    return dateNow;
}

//精确到天
- (NSString *)exactToDay {
    NSString *dateString = [self dateToString:self withDateFormat:@"yyyy-MM-dd"];
    
    return dateString;
}

//精确到小时
- (NSString *)exactToHour {
    NSString *dateString = [self dateToString:self withDateFormat:@"yyyy-MM-dd HH"];
    
    return dateString;
}

//精确到分
- (NSString *)exactToMinute {
    NSString *dateString = [self dateToString:self withDateFormat:@"yyyy-MM-dd HH:mm"];
    
    return dateString;
}

//精确到秒
- (NSString *)exactToSecond {
    NSString *dateString = [self dateToString:self withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return dateString;
}

//日期格式转字符串
- (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

//字符串转日期格式
- (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

@end
