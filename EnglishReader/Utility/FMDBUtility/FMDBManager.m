//
//  FMDBManager.m
//  QuanMinTV
//
//  Created by QMTV on 16/5/13.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#define DataBaseInfoDirectoryName @"DataBaseInfo"
#define DataBaseName @"ERDataBase"

#import "FMDBManager.h"
#import "FileManager.h"

@interface FMDBManager ()
@property (nonatomic, copy) NSString *currentDataBase;
@property (nonatomic, strong) FMDatabaseQueue *queue;
@end

@implementation FMDBManager

-(instancetype)init{
    self = [super init];
    
    if (self) {
        [self useDataBaseWithName:DataBaseName];
    }
    return self;
}
/**
 *  单例对象
 *
 *  @return 实例
 */
+ (instancetype)shareManager{
    static FMDBManager *_shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_shareManager == nil) {
            _shareManager = [[FMDBManager alloc] init];
        }
    });
    return _shareManager;
}
/**
 *  当前正在使用的数据库名字
 */
-(NSString *)currentDataBaseName{
    
    return _currentDataBase;
}
/**
 *  创建一个数据库
 *
 *  @param dataBaseName 数据库名字
 *
 *  @return 是否创建成功
 */
-(BOOL)creatDataBaseWithName:(NSString *)dataBaseName{
    NSAssert([dataBaseName isKindOfClass:[NSString class]], @"dataBaseName must be NSString or subClass");
    
    if (dataBaseName.length > 100) {
        dataBaseName = [dataBaseName substringToIndex:100];
    }
    
    _currentDataBase = dataBaseName;
    __block BOOL successed = NO;
    BOOL documentExist = [FileManager creatDocumentSubDirectoryWithString:DataBaseInfoDirectoryName];
    if (documentExist) {
        NSString *dataBaseDirectory = [FileManager getDocumentSubDirectoryWithString:DataBaseInfoDirectoryName];
        
        NSString *dataBase = [NSString stringWithFormat:@"%@.sqlite", dataBaseName];
        // 0.获得沙盒中的数据库文件名
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", dataBaseDirectory, dataBase];
        NSLog(@"filePath = %@", filePath);
        
        // 1.创建数据库实例对象
        _queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
        successed = YES;
    }
    
    return successed;
}

/**
 *  使用数据库
 *
 *  @param dataBaseName 数据库名字
 *
 *  @return 是否成功
 */
-(BOOL)useDataBaseWithName:(NSString *)dataBaseName{
    
    return [self creatDataBaseWithName:dataBaseName];
}

/**
 *  查询表是否存在
 *
 *  @param tableName 表名字
 *
 *  @return 存在返回YES;
 */
-(BOOL)tableExists:(NSString*)tableName{
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    __block BOOL exist = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        exist = [db tableExists:tableName];
        
        
    }];
    
    
    return exist;
}
/**
 *  删除表
 *
 *  @param tableName 要删除的表名字
 *
 *  @return 删除成功返回YES
 */
-(BOOL)deleteTable:(NSString *)tableName{
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@;", tableName];
            // 创表
            result = [db executeUpdate:sql];
            
        }else{
            result = NO;
            NSLog(@"数据库打开失败");
        }
    }];
    
    return result;
}
/**
 *  通过SQL语句创建表
 *
 *  @param sql SQL语句
 *
 *  @return 是否创建成功
 */
-(BOOL)creatTableBySQL:(NSString *)sql{
    NSAssert([sql isKindOfClass:[NSString class]], @"sql must be NSString or subClass");
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            // 创表
            result = [db executeUpdate:sql];
            
        }else{
            result = NO;
            NSLog(@"数据库打开失败");
        }
    }];
    
    return result;
}
/**
 *  创建一张表
 *
 *  @param tableName     表名字
 *  @param attributeDict 表字段及类型组成的字典
 *
 *  @return 是否创建成功
 */
-(BOOL)creatTableWithName:(NSString *)tableName withAttributeDictionary:(NSDictionary *)attributeDict{
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    NSAssert([attributeDict isKindOfClass:[NSDictionary class]], @"attributeDict must be NSDictionary or subClass");
    
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSArray *nameArray = [attributeDict allKeys];
            NSArray *typeArray = [attributeDict allValues];
            
            NSMutableString *attributeStr = [NSMutableString string];
            
            for (int i = 0; i < nameArray.count; i++) {
                NSString *attri = [NSString stringWithFormat:@", %@ %@", nameArray[i], typeArray[i]];
                [attributeStr appendString:attri];
            }
            
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (identifier integer primary key autoincrement %@);", tableName, attributeStr];
            // 创表
            result = [db executeUpdate:sql];
            
        }else{
            result = NO;
            NSLog(@"数据库打开失败");
        }
    }];
    
    
    return result;
}

/**
 *  获取数据库中所有的表名
 *
 *  @param dataBaseName 数据库名字
 *
 *  @return 表名列表
 */
-(NSArray *)getAllTableNameWithDataBaseName:(NSString *)dataBaseName{
    NSMutableArray *tableNames = [NSMutableArray array];
    
    return tableNames;
}
/**
 *  获取表中所有的字段及其对应的数据类型
 *
 *  @param tableName 表名字
 *
 *  @return 表中字段及其对应的数据类型组成的字典
 */
-(NSDictionary *)getTableAttributesWithTableName:(NSString *)tableName{
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet * result = [db getTableSchema:tableName];
            while ([result next]) {
                [attributes setValue:result.resultDictionary[@"type"] forKey:result.resultDictionary[@"name"]];
            }
        }
    }];
    
    return attributes;
}

/**
 *  将一个字典插入一张表中,字典中包含的key要与表中的字段一一对应
 *
 *  @param dictionary 键值对字典
 *  @param tableName 表名字
 *
 *  @return 插入成功 返回YES;
 */
- (BOOL)insertRecordWithDictionary:(NSDictionary *)dictionary toTable:(NSString *)tableName {
     NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
     NSAssert([dictionary isKindOfClass:[NSDictionary class]], @"dictionary must be NSDictionary or subClass");
    __block BOOL successed = NO;
    NSString *insertSQL = [self getInsertSQLWithDictionary:dictionary withTableName:tableName];
    successed = [self executeUpdateSQL:insertSQL];

    return successed;
}

/**
 *  删除表中的一行数据
 *
 *  @param dictionary 要删除的数据
 *  @param tableName  表名字
 *
 *  @return 删除成功 返回YES;
 */
- (BOOL)deleteRecordWithConditionDict:(NSDictionary *)dictionary inTable:(NSString *)tableName{
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block BOOL successed = NO;
    NSString *deleteSQL = [self getDeleteSQLWithConditionDict:dictionary withTableName:tableName];
    successed = [self executeUpdateSQL:deleteSQL];
    
    return successed;
}
/**
 *  更新表中对应的一行数据,字典中包含的key要与表中的字段一一对应
 *
 *  @param dictionary 新数据
 *  @param tableName  表名字
 *
 *  @return 更新成功 返回YES;
 */
- (BOOL)updateRecordWithDictionary:(NSDictionary *)dictionary inTable:(NSString *)tableName withConditionDictionary:(NSDictionary *)conditionDict{
    NSAssert([dictionary isKindOfClass:[NSDictionary class]], @"dictionary must be NSDictionary or subClass");
    NSAssert([conditionDict isKindOfClass:[NSDictionary class]], @"conditionDict must be NSDictionary or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block BOOL successed = NO;
    NSString *updateSQL = [self getUpdateSQLWithConditionDict:conditionDict newDictionary:dictionary withTableName:tableName];
    successed = [self executeUpdateSQL:updateSQL];
    
    return successed;
}

/**
 *  获取表中所有的记录
 *
 *  @param tableName 表名字
 *  @param attributes      表中所有字段及其对应的数据类型组成的字典
 *
 *  @return 查到的结果
 */
- (NSArray *)queryAllRecordInTable:(NSString *)tableName{
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    NSMutableArray *resultArray = [NSMutableArray array];
    NSDictionary *attributes = [self getTableAttributesWithTableName:tableName];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql1 = [NSString stringWithFormat:@"select * from %@;", tableName];
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:sql1];
        // 2.遍历结果集
        while (rs.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (NSString *key in attributes) {
                NSString *value = [rs objectForColumnName:key];
                [dict setValue:value forKey:key];
            }
            
            [resultArray addObject:dict];
        }
    }];
    
    return resultArray;
}

/**
 *  查找表中符合条件的记录
 *
 *  @param tableName     记录所在的表名字
 *  @param conditionDict 记录需要符合的条件
 *
 *  @return 找的的结果
 */
- (NSArray *)queryRecordInTable:(NSString *)tableName withConditionDictionary:(NSDictionary *)conditionDict{
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    NSAssert([conditionDict isKindOfClass:[NSDictionary class]], @"conditionDict must be NSDictionary or subClass");
    NSMutableArray *resultArray = [NSMutableArray array];
    NSDictionary *attributes = [self getTableAttributesWithTableName:tableName];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySQL = [self getQuerySQLWithConditionDict:conditionDict withTableName:tableName];
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:querySQL];
        // 2.遍历结果集
        while (rs.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (NSString *key in attributes) {
                NSString *value = [rs objectForColumnName:key];
                [dict setValue:value forKey:key];
            }
            
            [resultArray addObject:dict];
        }
    }];
    
    return resultArray;
}
/**
 *  执行自定义的SQL语句
 *
 *  @param sql 要执行的SQL语句
 *
 *  @return SQL语句执行成功,返回YES
 */
-(BOOL)executeUpdateSQL:(NSString *)sql{
    NSAssert([sql isKindOfClass:[NSString class]], @"sql must be NSString or subClass");
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    return result;
}
/**
 *  通过dictionary和tableName,生成一条insert的sql语句
 *
 *  @param dictionary 要插入的属性及其对应的值
 *  @param tabelName  对应的表名字
 *  @return 生成的insert,SQL语句
 */
-(NSString *)getInsertSQLWithDictionary:(NSDictionary *)dictionary withTableName:(NSString *)tableName{
    NSAssert([dictionary isKindOfClass:[NSDictionary class]], @"dictionary must be NSDictionary or subClass");
    
    __block NSString *insertSQL = [NSString string];
    
    NSArray *nameArray = [dictionary allKeys];
    NSArray *valueArray = [dictionary allValues];
    
    NSMutableString *nameStr = [NSMutableString string];
    NSMutableString *valueStr = [NSMutableString string];
    
    for (int i = 0; i< nameArray.count; i++) {
        if (i == 0) {
            NSString *name = [NSString stringWithFormat:@"%@", nameArray[i]];
            NSString *value = [NSString stringWithFormat:@"'%@'", valueArray[i]];
            [nameStr appendString:name];
            [valueStr appendString:value];
        }else{
            NSString *name = [NSString stringWithFormat:@", %@", nameArray[i]];
            NSString *value = [NSString stringWithFormat:@", '%@'", valueArray[i]];
            [nameStr appendString:name];
            [valueStr appendString:value];
        }
    }
    insertSQL = [NSString stringWithFormat:@"insert into %@ (%@) values (%@);", tableName, nameStr, valueStr];
    
    return insertSQL;
}

/**
 *  通过dictionary和tableName,生成一条delete的sql语句
 *
 *  @param conditionDict 要删除的记录的键值列表
 *  @param tableName     记录所在的表名字
 *
 *  @return 生成的DeleteSQL语句
 */
-(NSString *)getDeleteSQLWithConditionDict:(NSDictionary *)conditionDict withTableName:(NSString *)tableName{
    NSAssert([conditionDict isKindOfClass:[NSDictionary class]], @"conditionDict must be NSDictionary or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block NSString *deleteSQL = [NSString string];
    
    NSArray *nameArray = [conditionDict allKeys];
    NSArray *valueArray = [conditionDict allValues];
    
    NSMutableString *conditionStr = [NSMutableString string];
    
    for (int i = 0; i < nameArray.count; i++) {
        if (i == 0) {
            NSString *result = [NSString stringWithFormat:@"%@ = '%@'", nameArray[i], valueArray[i]];
            [conditionStr appendString:result];
        }else{
            NSString *result = [NSString stringWithFormat:@"and %@ = '%@' ", nameArray[i], valueArray[i]];
            [conditionStr appendString:result];
        }
    }
    
    deleteSQL = [NSString stringWithFormat:@"delete from %@ where %@;", tableName, conditionStr];

    return deleteSQL;
}

/**
 *  通过keyWordArray中的关键字更新tableName表中的某条记录
 *
 *  @param conditionDict 要查询的键值数组,用来定位表中唯一的记录
 *  @param newDictionary 新数据的键值对
 *  @param tableName    对应的表名字
 *
 *  @return 生成的updateSQL语句
 */
-(NSString *)getUpdateSQLWithConditionDict:(NSDictionary *)conditionDict newDictionary:(NSDictionary *)newDictionary withTableName:(NSString *)tableName{
     NSAssert([conditionDict isKindOfClass:[NSDictionary class]], @"conditionDict must be NSDictionary or subClass");
    NSAssert([newDictionary isKindOfClass:[NSDictionary class]], @"newDictionary must be NSDictionary or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block NSString *updateSQL = [NSString string];
    
    NSArray *nameArray = [newDictionary allKeys];
    NSArray *valueArray = [newDictionary allValues];
    
    NSMutableString *resultStr = [NSMutableString string];
    
    for (int i = 0; i < nameArray.count; i++) {
        if (i == 0) {
            NSString *result = [NSString stringWithFormat:@"%@ = '%@'", nameArray[i], valueArray[i]];
            [resultStr appendString:result];
        }else{
            NSString *result = [NSString stringWithFormat:@", %@ = '%@' ", nameArray[i], valueArray[i]];
            [resultStr appendString:result];
        }
        
        
    }
    
    NSArray *conditionNameArray = [conditionDict allKeys];
    NSArray *conditionValueArray = [conditionDict allValues];
    
    NSMutableString *conditionStr = [NSMutableString string];
    
    for (int j = 0; j < conditionNameArray.count; j++) {
        
        if (j == 0) {
            NSString *result = [NSString stringWithFormat:@"%@ = '%@'", conditionNameArray[j], conditionValueArray[j]];
            [conditionStr appendString:result];
        }else{
            NSString *result = [NSString stringWithFormat:@"and %@ = '%@'", conditionNameArray[j], conditionValueArray[j]];
            [conditionStr appendString:result];
        }
        
    }
    
    updateSQL = [NSString stringWithFormat:@"update %@ set %@ where %@;", tableName, resultStr, conditionStr];
    
    return updateSQL;
}
/**
 *  通过conditionDict生成查询的SQL语句
 *
 *  @param conditionDict 要查询的条件的键值对
 *  @param tableName     记录所在的表名字
 *
 *  @return 生成的querySQL语句
 */
-(NSString *)getQuerySQLWithConditionDict:(NSDictionary *)conditionDict withTableName:(NSString *)tableName{
    NSAssert([conditionDict isKindOfClass:[NSDictionary class]], @"conditionDict must be NSDictionary or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block NSString *querysSQL = [NSString string];
    NSArray *conditionNameArray = [conditionDict allKeys];
    NSArray *conditionValueArray = [conditionDict allValues];
    
    NSMutableString *conditionStr = [NSMutableString string];
    
    for (int j = 0; j < conditionNameArray.count; j++) {
        
        if (j == 0) {
            NSString *result = [NSString stringWithFormat:@"%@ = '%@'", conditionNameArray[j], conditionValueArray[j]];
            [conditionStr appendString:result];
        }else{
            NSString *result = [NSString stringWithFormat:@", %@ = '%@'", conditionNameArray[j], conditionValueArray[j]];
            [conditionStr appendString:result];
        }
    }
    
    querysSQL = [NSString stringWithFormat:@"select * from %@ where %@;", tableName, conditionStr];
    
    return querysSQL;
}
/**
 *  在指定的表中,新增一个int型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addIntColumnWitnName:(NSString *)columnName inTable:(NSString *)tableName{
    NSAssert([columnName isKindOfClass:[NSString class]], @"columnName must be NSString or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD `%@` integer NULL  DEFAULT NULL;", tableName, columnName];
        result = [db executeUpdate:sql];
    }];
    
    return result;
}
/**
 *  在指定的表中,新增一个float型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addFloatColumnWitnName:(NSString *)columnName inTable:(NSString *)tableName{
    NSAssert([columnName isKindOfClass:[NSString class]], @"columnName must be NSString or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD `%@` FLOAT  NULL  DEFAULT NULL;", tableName, columnName];
        result = [db executeUpdate:sql];
        
    }];
    
    return result;
}
/**
 *  在指定的表中,新增一个字符型的字段
 *
 *  @param columnName 字段名字
 *  @param length     字符长度
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addVarcharColumnWithName:(NSString *)columnName andLength:(int) length inTable:(NSString *)tableName{
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    NSAssert([columnName isKindOfClass:[NSString class]], @"columnName must be NSString or subClass");
    
    if (length > INT_MAX || length < INT_MIN) {
        length = 140;
    }
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD `%@` VARCHAR(%d)  CHARACTER SET utf8  COLLATE utf8_general_ci  NULL  DEFAULT NULL;", tableName, columnName, length];
        result = [db executeUpdate:sql];
        
    }];
    
    return result;
}
/**
 *  在指定的表中,新增一个bool型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addBoolColumnWithName:(NSString *)columnName inTable:(NSString *)tableName{
    NSAssert([columnName isKindOfClass:[NSString class]], @"columnName must be NSString or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD `%@` BOOL  NULL  DEFAULT NULL;", tableName, columnName];
        result = [db executeUpdate:sql];
        
    }];
    
    return result;
}
/**
 *  在指定的表中,新增一个date型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addDateColumnWithName:(NSString *)columnName inTable:(NSString *)tableName{
    NSAssert([columnName isKindOfClass:[NSString class]], @"columnName must be NSString or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD `%@` DATE  NULL;", tableName, columnName];
        result = [db executeUpdate:sql];
        
    }];
    
    return result;
}
/**
 *  在指定的表中,新增一个dateTime型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addDateTimeColumnWithName:(NSString *)columnName inTable:(NSString *)tableName{
    NSAssert([columnName isKindOfClass:[NSString class]], @"columnName must be NSString or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    __block BOOL result;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD `%@` DATETIME  NULL;", tableName, columnName];
        result = [db executeUpdate:sql];
        
    }];

    return result;
}
/**
 *  在指定的表中,新增一个Time型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addTimeColumnWithName:(NSString *)columnName inTable:(NSString *)tableName{
    NSAssert([columnName isKindOfClass:[NSString class]], @"columnName must be NSString or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD `%@` TIME  NULL;", tableName, columnName];
        result = [db executeUpdate:sql];
        
    }];
    
    return result;
}
/**
 *  在指定的表中,新增一个blob型的字段
 *
 *  @param columnName 字段名字
 *  @param tableName  对应的表名字
 *
 *  @return 添加成功返回YES
 */
-(BOOL)addBlobColumnWithName:(NSString *)columnName inTable:(NSString *)tableName{
    NSAssert([columnName isKindOfClass:[NSString class]], @"columnName must be NSString or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD `%@` BLOB  NULL  AFTER `nishuone`;", tableName, columnName];
        result = [db executeUpdate:sql];
        
    }];
    
    return result;
}

/**
 *  删除表中指定的字段
 *
 *  @param columnName 要删除的字段名字
 *  @param tableName  字段所在的表名字
 *
 *  @return 删除成功返回YES
 */
-(BOOL)deleteColumnWithName:(NSString *)columnName inTable:(NSString *)tableName{
    NSAssert([columnName isKindOfClass:[NSString class]], @"columnName must be NSString or subClass");
    NSAssert([tableName isKindOfClass:[NSString class]], @"tableName must be NSString or subClass");
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABEL `%@` DORP COLUMN %@ IF EXISTS %@;", tableName, columnName, columnName];
        result = [db executeUpdate:sql];
    }];
    
    return result;
}
@end
