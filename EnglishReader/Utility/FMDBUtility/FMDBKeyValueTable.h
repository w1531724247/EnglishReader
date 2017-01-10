//
//  FMDBKeyValueTable.h
//  QuanMinTV
//
//  Created by QMTV on 16/5/19.
//  Copyright © 2016年 QMTV. All rights reserved.
//
// TODO: [数据库整理（系统设置，用户信息）]

#import <Foundation/Foundation.h>
#import "FMDBManager.h"

/**
 *  用来存储key和Value的表
 */
#define KeyValueTable @"KeyValueTable"

/**
 *  代表了数据库中的一张表, 通过这个类来操作这张表
 */
@interface FMDBKeyValueTable : NSObject

/**
 *  单例对象,你总是应该通过单例使用这个类
 *
 *  @return 单例
 */
+(instancetype)shareTable;
/**
 *  通过key来取表中对应的值, 字典和数组返回的是jsonString需要将jsonString 转化一下的得到对应的对象
 *
 *  @param key
 *
 *  @return key对应的值, 如果不存在key对应value, 或者key对应的value为空的返回nil
 */
-(id)getValueForKey:(NSString *)key;
/**
 *  在表中添加一条记录,如果记录不存在,在添加一条新的,如果记录存在则更新那条记录(用新value替换掉旧value)
 *  字典和数组需要转化为json字符串存储
 *  @param value key对应的值, 传入nil将删除key对应的记录
 *  @param key   只对应的key
 *
 *  @return 设置成功返回YES
 */
-(BOOL)setValue:(id)value forKey:(NSString *)key;
/**
 *  通过key删除一条记录
 *
 *  @param key 要删除的记录对应的key
 *
 *  @return 删除成功返回YES
 */
-(BOOL)deleteValueForKey:(NSString *)key;
/**
 *  将一个字典作为key的值存起来
 *
 *  @param aDictionary 要存的字典
 *  @param key         对应的key
 *
 *  @return 存储成功返回YES
 */
-(BOOL)setDictionary:(NSDictionary *)aDictionary forKey:(NSString *)key;
/**
 *  通过一个key获取存储的字典的值
 *
 *  @param key 字典对应的key
 *
 *  @return 找到的字典
 */
-(NSDictionary *)getDictionaryForKey:(NSString *)key;
/**
 *  将一个数组作为key的值存起来
 *
 *  @param anArray 要存的数组
 *  @param key     对应的key
 *
 *  @return 存储成功返回YES
 */
-(BOOL)setArray:(NSArray *)anArray forKey:(NSString *)key;

/**
 *  通过一个key获取存储的数组的值
 *
 *  @param key 数组对应的key
 *
 *  @return 找到的数组
 */
-(NSArray *)getArrayForKey:(NSString *)key;

- (NSString*)arrayToJsonString:(NSArray *)array;

@end
