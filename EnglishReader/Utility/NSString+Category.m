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
@end
