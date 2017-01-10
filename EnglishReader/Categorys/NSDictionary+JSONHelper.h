//
//  NSDictionary+JSONHelper.h
//  QuanMinTV
//
//  Created by QMTV on 16/5/23.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONHelper)
/**
 *  Number
 *  String
 *  Boolean
 *  Array
 *  Value
 *  Object
 *  Whitespace
 *  null
 */

/**
 *  通过key获取int型的值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回0
 */
-(int)getIntForKey:(NSString *)key;

/**
 *  通过key获取long型的值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回0
 */
-(long)getLongForKey:(NSString *)key;

/**
 *  通过key获取float型的值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回0.0
 */
-(float)getFloatForKey:(NSString *)key;

/**
 *  通过key获取string型的值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回空字符串
 */
-(NSString *)getStringForKey:(NSString *)key;

/**
 *  通过key获取BOOL型的值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回NO
 */
-(BOOL)getBoolForKey:(NSString *)key;

/**
 *  通过key获取NSArray型的值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回空数组
 */
-(NSArray *)getArrayForKey:(NSString *)key;

/**
 *  获取jsonString中某个字段的值,注意!!!这里可能返回任意类型的值,有类型安全隐患
 *
 *  @param key
 *
 *  @return 得到的值,  如果解析出错或解析不到,返回-1
 */
-(id)getValueForKey:(NSString *)key;

/**
 *  获取jsonString中某个字段的值
 *
 *  @param key
 *
 *  @return 得到的值, 如果解析出错或解析不到,返回空字典
 */
-(NSDictionary *)getObjectForKey:(NSString *)key;

@end
