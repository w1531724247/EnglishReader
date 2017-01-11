//
//  NSDictionary+NSString.h
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSString)

/**
 *  把字典转化为json字符串
 *
 *  @param dic 要转换的字典
 *
 *  @return 转换后的json字符串
 */
- (NSString*)dictionaryToJsonString;


@end
