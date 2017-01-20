//
//  NSDictionary+JSONHelper.m
//  QuanMinTV
//
//  Created by QMTV on 16/5/23.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "NSDictionary+JSONHelper.h"

@implementation NSDictionary (JSONHelper)


/**
 *  通过key获取int值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回0
 */
-(int)getIntForKey:(NSString *)key{
#ifdef DEBUG
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
#endif
    int value = -9786;
    if ([[self valueForKey:key] respondsToSelector:@selector(intValue)]) {
        value = [[self valueForKey:key] intValue];
    }
    
    return value;
}

/**
 *  通过key获取long型的值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回0
 */
-(long)getLongForKey:(NSString *)key {
#ifdef DEBUG
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
#endif
    long value = 0;
    if ([[self valueForKey:key] respondsToSelector:@selector(longValue)]) {
        value = [[self valueForKey:key] longValue];
    }
    
    return value;
}

/**
 *  通过key获取float型的值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回0.0
 */
-(float)getFloatForKey:(NSString *)key{
#ifdef DEBUG
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
#endif
    float value = 0.0f;
    if ([[self valueForKey:key] respondsToSelector:@selector(floatValue)]) {
        value = [[self valueForKey:key] floatValue];
    }
    
    return value;
}
/**
 *  通过key获取string型的值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回空字符串
 */
-(NSString *)getStringForKey:(NSString *)key{
#ifdef DEBUG
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
#endif
    NSString *string = nil;
    
    NSString *strObj = [self valueForKey:key];
    if ([strObj isKindOfClass:[NSString class]]) {
        string = (NSString *)strObj;
    } else if ([strObj respondsToSelector:@selector(integerValue)]) {
        string = [NSString stringWithFormat:@"%zi",strObj.integerValue];
    } else {
        string = @"";
    }
    
    return string;
}

/**
 *  通过key获取BOOL型的值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回NO
 */
-(BOOL)getBoolForKey:(NSString *)key{
#ifdef DEBUG
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
#endif
    BOOL value = NO;
    if ([[self valueForKey:key] respondsToSelector:@selector(boolValue)]) {
        value = [[self valueForKey:key] boolValue];
    }
    
    return value;
}

/**
 *  通过key获取NSArray型的值
 *
 *  @param key
 *
 *  @return 得到的结果, 如果解析不到, 或者解析出错返回空数组
 */
-(NSArray *)getArrayForKey:(NSString *)key{
#ifdef DEBUG
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
#endif
    NSArray *array = [self valueForKey:key];
    if ([array isKindOfClass:[NSArray class]]) {
        return array;
    }else{
        // array为dictionary时候会崩
        //        array = [NSArray arrayWithArray:array];
        array = @[];
        return array;
    }
}

/**
 *  获取jsonString中某个字段的值,注意!!!这里可能返回任意类型的值,有类型安全隐患
 *
 *  @param key
 *
 *  @return 得到的值,  如果解析出错或解析不到,返回NSObject对像
 */
-(id)getValueForKey:(NSString *)key{
#ifdef DEBUG
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
#endif
    return [self valueForKey:key];
}

/**
 *  获取jsonString中某个字段的值
 *
 *  @param key
 *
 *  @return 得到的值, 如果解析出错或解析不到,返回空字典
 */
-(NSDictionary *)getObjectForKey:(NSString *)key{
    NSDictionary *dictionary = [self valueForKey:key];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        return dictionary;
    }else{
        return [NSDictionary dictionary];
    }
}

@end
