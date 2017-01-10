//
//  FMDBManager.h
//  QuanMinTV
//
//  Created by QMTV on 16/5/13.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
/**
 *  <#Description#>
 */
@interface FMDBManager : NSObject

/**
 *  当前正在使用的数据库名字
 */
@property (nonatomic, copy, readonly) NSString *currentDataBaseName;
/**
 *  单例对象
 *
 *  @return 实例
 */
+ (instancetype)shareManager;
/**
 *  创建一个数据库
 *
 *  @param dataBaseName 数据库名字
 *
 *  @return 创建成功 返回YES;
 */
-(BOOL)creatDataBaseWithName:(NSString *)dataBaseName;
/**
 *  使用数据库
 *
 *  @param dataBaseName 数据库名字
 *
 *  @return 成功 返回YES;
 */
-(BOOL)useDataBaseWithName:(NSString *)dataBaseName;
/**
 *  查询表是否存在
 *
 *  @param tableName 表名字
 *
 *  @return 存在返回YES;
 */
-(BOOL)tableExists:(NSString*)tableName;
/**
 *  删除表
 *
 *  @param tableName 要删除的表名字
 *
 *  @return 删除成功返回YES
 */
-(BOOL)deleteTable:(NSString *)tableName;
/**
 *  通过SQL语句创建表
 *
 *  @param sql SQL语句
 *
 *  @return 创建成功 返回YES;
 */
-(BOOL)creatTableBySQL:(NSString *)sql;
/**
 *  创建一张表
 *
 *  @param tableName     表名字
 *  @param attributeDict 表字段及类型组成的字典
 *
 *  @return 创建成功 返回YES;
 */
-(BOOL)creatTableWithName:(NSString *)tableName withAttributeDictionary:(NSDictionary *)attributeDict;

/**
 *  获取数据库中所有的表名
 *
 *  @param dataBaseName 数据库名字
 *
 *  @return 表名列表
 */
-(NSArray *)getAllTableNameWithDataBaseName:(NSString *)dataBaseName;
/**
 *  获取表中所有的字段及其对应的数据类型
 *
 *  @param tableName 记录所在的表名字
 *
 *  @return 表中字段及其对应的数据类型组成的字典
 */
-(NSDictionary *)getTableAttributesWithTableName:(NSString *)tableName;

/**
 *  将一个字典插入一张表中,字典中包含的key要与表中的字段一一对应
 *
 *  @param dictionary 键值对字典
 *  @param tableName 记录所在的表名字
 *
 *  @return 插入成功 返回YES;
 */
- (BOOL)insertDictionary:(NSDictionary *)dictionary toTable:(NSString *)tableName;
/**
 *  删除表中的一行数据
 *
 *  @param dictionary 要删除的数据
 *  @param tableName  记录所在的表名字
 *
 *  @return 删除成功 返回YES;
 */
- (BOOL)deleteRecordWithConditionDict:(NSDictionary *)dictionary inTable:(NSString *)tableName;
/**
 *  更新表中对应的一行数据,字典中包含的key要与表中的字段一一对应
 *
 *  @param dictionary 新数据
 *  @param tableName  记录所在的表名字
 *
 *  @return 更新成功 返回YES;
 */
- (BOOL)updateDictionary:(NSDictionary *)dictionary inTable:(NSString *)tableName withConditionDictionary:(NSDictionary *)conditionDict;
/**
 *  获取表中所有的记录
 *
 *  @param tableName       记录所在的表名字
 *  @param attributes      表中所有字段组成的数组
 *
 *  @return 查到的结果
 */
- (NSArray *)queryAllRecordInTable:(NSString *)tableName;
/**
 *  查找表中符合条件的记录
 *
 *  @param tableName     记录所在的表名字
 *  @param conditionDict 记录需要符合的条件
 *
 *  @return 找的的结果
 */
- (NSArray *)queryRecordInTable:(NSString *)tableName withConditionDictionary:(NSDictionary *)conditionDict;
/**
 *  执行自定义的SQL语句
 *
 *  @param sql 要执行的SQL语句
 *
 *  @return SQL语句执行成功,返回YES
 */
-(BOOL)executeUpdateSQL:(NSString *)sql;
/**
 *  通过dictionary和tableName,生成一条insert的sql语句
 *
 *  @param dictionary 要插入的属性及其对应的值
 *  @param tabelName  记录所在的表名字
 *  @return 生成的insert,SQL语句
 */
-(NSString *)getInsertSQLWithDictionary:(NSDictionary *)dictionary withTableName:(NSString *)tableName;
/**
 *  通过conditionDict和tableName,生成一条delete的sql语句
 *
 *  @param conditionDict 要删除的记录的键值列表
 *  @param tableName     记录所在的表名字
 *
 *  @return 生成的DeleteSQL语句
 */
-(NSString *)getDeleteSQLWithConditionDict:(NSDictionary *)conditionDict withTableName:(NSString *)tableName;
/**
 *  通过keyWordArray中的关键字, 生成一条update的sql语句
 *
 *  @param conditionDict 要查询的键值数组,用来定位表中唯一的记录
 *  @param newDictionary 新数据的键值对
 *  @param tableName    记录所在的表名字
 *
 *  @return 生成的updateSQL语句
 */
-(NSString *)getUpdateSQLWithConditionDict:(NSDictionary *)conditionDict newDictionary:(NSDictionary *)newDictionary withTableName:(NSString *)tableName;
/**
 *  通过conditionDict生成查询的SQL语句
 *
 *  @param conditionDict 要查询的条件的键值对
 *  @param tableName     记录所在的表名字
 *
 *  @return 生成的querySQL语句
 */
-(NSString *)getQuerySQLWithConditionDict:(NSDictionary *)conditionDict withTableName:(NSString *)tableName;
/**
 *  在指定的表中,新增一个int型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addIntColumnWitnName:(NSString *)columnName inTable:(NSString *)tableName;
/**
 *  在指定的表中,新增一个float型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addFloatColumnWitnName:(NSString *)columnName inTable:(NSString *)tableName;
/**
 *  在指定的表中,新增一个字符型的字段
 *
 *  @param columnName 字段名字
 *  @param length     字符长度
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addVarcharColumnWithName:(NSString *)columnName andLength:(int) length inTable:(NSString *)tableName;
/**
 *  在指定的表中,新增一个bool型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addBoolColumnWithName:(NSString *)columnName inTable:(NSString *)tableName;
/**
 *  在指定的表中,新增一个date型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addDateColumnWithName:(NSString *)columnName inTable:(NSString *)tableName;
/**
 *  在指定的表中,新增一个dateTime型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addDateTimeColumnWithName:(NSString *)columnName inTable:(NSString *)tableName;
/**
 *  在指定的表中,新增一个Time型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addTimeColumnWithName:(NSString *)columnName inTable:(NSString *)tableName;
/**
 *  在指定的表中,新增一个blob型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addBlobColumnWithName:(NSString *)columnName inTable:(NSString *)tableName;

/**
 *  删除表中指定的字段
 *
 *  @param columnName 要删除的字段名字
 *  @param tableName  字段所在的表名字
 *
 *  @return 删除成功返回YES
 */
-(BOOL)deleteColumnWithName:(NSString *)columnName inTable:(NSString *)tableName;

@end
