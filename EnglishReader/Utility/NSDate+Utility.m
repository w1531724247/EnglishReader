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

@end
