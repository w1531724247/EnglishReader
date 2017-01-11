//
//  NSDictionary+NSString.m
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "NSDictionary+NSString.h"

@implementation NSDictionary (NSString)

/**
 *  把字典转化为json字符串
 *
 *  @param dic 要转换的字典
 *
 *  @return 转换后的json字符串
 */
- (NSString*)dictionaryToJsonString

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
        return [NSString string];
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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

@end
