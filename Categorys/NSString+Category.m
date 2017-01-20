//
//  NSString+Category.m
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */
- (NSArray *)arrayWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return [NSArray array];
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&err];
    
    if(err) {
        return [NSArray array];
    }
    else {
        
    }
    return array;
}
/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return [NSDictionary dictionary];
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        //        NSLog(@"json解析失败：%@",err);
        return [NSDictionary dictionary];
    }
    return dic;
}

/*
 判断是否是中文
 */
- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

/*
 提取字符串中的第一串中文
 */
- (NSString *)extractFirstChinsesStringFromRefrenceHTML {
    if (self.length < 1) {
        return [NSString string];
    }
    
    if (![self isKindOfClass:[NSString class]]) {
        return [NSString string];
    }
    
    NSMutableString *chineseString = [NSMutableString string];
    
    BOOL findChinese = NO;
    NSRange bodyRang = [self rangeOfString:@"<body>"];
    NSString *bodyString = [self substringFromIndex:bodyRang.location];
    NSInteger length = bodyString.length;
    for (int i = 0; i < length; i++) {
        NSString *chinese = [bodyString substringWithRange:NSMakeRange(i, 1)];
        
        if ([chinese isChinese]) {//判断是否为中文
            findChinese = YES;
            [chineseString appendString:chinese];
        } else {
            if (findChinese) {
                break;
            }
        }
    }
    
    return chineseString;
}

@end
