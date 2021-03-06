//
//  NSDate+Utility.h
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

//获取当前系统时间
+ (NSDate *)currentDate;
//精确到天
- (NSString *)exactToDay;
//精确到小时
- (NSString *)exactToHour;
//精确到分
- (NSString *)exactToMinute;
//精确到秒
- (NSString *)exactToSecond;

@end
