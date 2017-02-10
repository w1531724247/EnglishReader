//
//  NSString+Category.h
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */
- (NSArray *)arrayWithJsonString:(NSString *)jsonString;

/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*
 判断是否是中文
 */
- (BOOL)isChinese;

/*
    提取字符串中的第一串连续的中文字符串
 */
- (NSString *)extractFirstChinsesStringFromRefrenceHTML;
@end
