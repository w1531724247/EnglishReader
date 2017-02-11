//
//  DocsetHelper.m
//  EnglishReader
//
//  Created by QMTV on 17/2/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "DocsetHelper.h"
#import "FMDB.h"
#import "DSType.h"
#import "DSEntry.h"
#import "YYKit.h"

@interface DocsetHelper ()

@end

@implementation DocsetHelper

- (NSArray *)typeListWithDocsetPath:(NSString *)docsetPath {
    NSArray *types = [NSArray array];
    if (![docsetPath isKindOfClass:[NSString class]] || docsetPath.length < 1) {
        return types;
    }
    
    NSString *plistPath = [docsetPath stringByAppendingPathComponent:@".types.plist"];
    NSDictionary *typesDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *typeArray = typesDict[@"types"];
    if(typesDict && typeArray && [typeArray isKindOfClass:[NSArray class]] && [typeArray count])
    {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in typeArray) {
            DSType *type = [DSType modelWithDictionary:dict];
            [tempArray addObject:type];
        }
        types =  [tempArray copy];
    }
    
    return types;
}

- (NSArray *)entryListWithDocsetPath:(NSString *)docsetPath andType:(NSString *)type {
    NSString *docsetSQLPath = [docsetPath stringByAppendingPathComponent:@"Contents/Resources/optimisedIndex.dsidx"];
    FMDatabase *db = [FMDatabase databaseWithPath:docsetSQLPath];
    NSMutableArray *entries = [NSMutableArray array];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:@"SELECT path, name, type FROM searchIndex WHERE type = ? ORDER BY LOWER(name)", type];
        BOOL next = [rs next];
        while(next)
        {
            DSEntry *entry = [[DSEntry alloc] init];
            entry.path = [rs stringForColumnIndex:0];
            entry.name = [rs stringForColumnIndex:1];
            entry.type = [rs stringForColumnIndex:2];
            [entries addObject:entry];
            
            next = [rs next];
        }
        
        [db close];
    }

    return [entries copy];
}

@end
