//
//  NSArray+NSString.m
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "NSArray+NSString.h"

@implementation NSArray (NSString)

/**
 *  把数组转化为json字符串
 *
 *  @param array 要转换的字典
 *
 *  @return 转换后的json字符串
 */
- (NSString *)arrayToJsonString

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (parseError) {
        return [NSString string];
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
