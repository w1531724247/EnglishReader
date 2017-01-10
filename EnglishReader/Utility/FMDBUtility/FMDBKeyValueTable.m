//
//  FMDBKeyValueTable.m
//  QuanMinTV
//
//  Created by QMTV on 16/5/19.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "FMDBKeyValueTable.h"

@interface FMDBKeyValueTable ()

@end

@implementation FMDBKeyValueTable

-(instancetype)init{
    self = [super init];
    if (self) {
        [[FMDBManager shareManager] creatTableWithName:KeyValueTable withAttributeDictionary:@{
                                                                                               @"key" : @"nvarchar",
                                                                                               @"value": @"nvarchar"
                                                                                               }];
    }
    return self;
}
/**
 *  单例对象,你总是应该通过单例使用这个类
 *
 *  @return 单例
 */
+(instancetype)shareTable{
    static FMDBKeyValueTable *_shareTable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == _shareTable) {
            _shareTable = [[FMDBKeyValueTable alloc] init];
        }
    });
    return _shareTable;
}
/**
 *  通过key来取表中对应的值
 *
 *  @param key
 *
 *  @return key对应的值
 */
-(id)getValueForKey:(NSString *)key{
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
    NSArray *objectArray = [[FMDBManager shareManager] queryRecordInTable:KeyValueTable withConditionDictionary:@{@"key":key}];
    if ([objectArray lastObject]) {
        NSDictionary *dictionary = [objectArray lastObject];
        id value = [dictionary valueForKey:@"value"];
        return value;
    }
    return [NSString string];
}
/**
 *  在表中添加一条记录,如果记录不存在,在添加一条新的,如果记录存在则更新那条记录(用新value替换掉旧value)
 *
 *  @param value key对应的值
 *  @param key   只对应的key
 *
 *  @return 设置成功返回YES
 */
-(BOOL)setValue:(id)value forKey:(NSString *)key{
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
    BOOL successed = NO;
    
    NSArray *objectArray = [[FMDBManager shareManager] queryRecordInTable:KeyValueTable withConditionDictionary:@{@"key":key}];
    if (nil == value) {
        successed = [[FMDBManager shareManager] deleteRecordWithConditionDict:@{@"key":key} inTable:KeyValueTable];
        return successed;
    }
    
    if([objectArray lastObject]){
        successed = [[FMDBManager shareManager] updateDictionary:@{@"key":key,
                                                                   @"value": value} inTable:KeyValueTable withConditionDictionary:@{@"key":key}];
    }else{
        successed = [[FMDBManager shareManager] insertDictionary:@{@"key":key,
                                                                   @"value": value} toTable:KeyValueTable];
    }
    
    return successed;
}

/**
 *  通过key删除一条记录
 *
 *  @param key 要删除的记录对应的key
 *
 *  @return 删除成功返回YES
 */
-(BOOL)deleteValueForKey:(NSString *)key{
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
    BOOL successed = NO;
    
    NSArray *objectArray = [[FMDBManager shareManager] queryRecordInTable:KeyValueTable withConditionDictionary:@{@"key":key}];
    if(objectArray.count > 0){
        successed = [[FMDBManager shareManager] deleteRecordWithConditionDict:@{@"key":key} inTable:KeyValueTable];
    }
    return successed;
}

/**
 *  将一个字典作为key的值存起来
 *
 *  @param aDictionary 要存的字典
 *  @param key         对应的key
 *
 *  @return 存储成功返回YES
 */
-(BOOL)setDictionary:(NSDictionary *)aDictionary forKey:(NSString *)key{
    NSAssert([aDictionary isKindOfClass:[NSDictionary class]], @"aDictionary must be NSDictionary or subClass");
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
    NSString *jsonString = [self dictionaryToJsonString:aDictionary];
    
    return [self setValue:jsonString forKey:key];
}
/**
 *  通过一个key获取存储的字典的值
 *
 *  @param key 字典对应的key
 *
 *  @return 找到的字典
 */
-(NSDictionary *)getDictionaryForKey:(NSString *)key{
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
    NSString *jsonString = [self getValueForKey:key];
    NSDictionary *dictionary = [self dictionaryWithJsonString:jsonString];
    
    return dictionary;
}
/**
 *  将一个数组作为key的值存起来
 *
 *  @param anArray 要存的数组
 *  @param key     对应的key
 *
 *  @return 存储成功返回YES
 */
-(BOOL)setArray:(NSArray *)anArray forKey:(NSString *)key{
    NSAssert([anArray isKindOfClass:[NSArray class]], @"anArray must be NSArray or subClass");
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
    NSString *jsonString = [self arrayToJsonString:anArray];
    
    return [self setValue:jsonString forKey:key];
}

/**
 *  通过一个key获取存储的数组的值
 *
 *  @param key 数组对应的key
 *
 *  @return 找到的数组
 */
-(NSArray *)getArrayForKey:(NSString *)key{
    NSAssert([key isKindOfClass:[NSString class]], @"key must be NSString or subClass");
    NSString *jsonString = [self getValueForKey:key];
    NSArray *array = [self arrayWithJsonString:jsonString];
    
    return array;
}

/**
 *  把数组转化为json字符串
 *
 *  @param array 要转换的字典
 *
 *  @return 转换后的json字符串
 */
- (NSString*)arrayToJsonString:(NSArray *)array

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

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
        NSLog(@"json解析失败：%@ _func_", err);
        return [NSArray array];
    }
    else {
        
    }
    return array;
}
/**
 *  把字典转化为json字符串
 *
 *  @param dic 要转换的字典
 *
 *  @return 转换后的json字符串
 */
- (NSString*)dictionaryToJsonString:(NSDictionary *)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
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
