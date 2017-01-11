//
//  StrangeWordTable.m
//  EnglishReader
//
//  Created by QMTV on 17/1/10.
//  Copyright © 2017年 LFC. All rights reserved.
//

#define kWord @"word"
#define kCreatDate @"creatDate"
#define kFirstUpperLetter @"firstUpperLetter"
#define kLookUpCount @"lookUpCount"
#define kArticles @"articles"

#define kStrangeWordTable @"StrangeWordTable"

#import "StrangeWordTable.h"
#import "FMDBManager.h"
#import "NSArray+NSString.h"
#import "NSDictionary+NSString.h"
#import "NSDate+Utility.h"
#import "NSDictionary+JSONHelper.h"
#import "NSString+Category.h"

@implementation StrangeWordTable

-(instancetype)init{
    self = [super init];
    if (self) {
        [[FMDBManager shareManager] creatTableWithName:kStrangeWordTable withAttributeDictionary:@{
                                                                                               @"word" : @"nvarchar",
                                                                                               @"creatDate": @"date",
                                                                                               @"chineseWord": @"nvarchar",
                                                                                               @"firstUpperLetter": @"nvarchar",
                                                                                               @"lookUpCount": @"integer",
                                                                                               @"articles": @"nvarchar"
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
    static StrangeWordTable *_shareTable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == _shareTable) {
            _shareTable = [[StrangeWordTable alloc] init];
        }
    });
    
    return _shareTable;
}

//添加一个单词
- (BOOL)addWord:(NSString *)word withArticleName:(NSString *)articleName {
    if (word.length < 1) {
        return NO;
    }
    
    if (![word isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    BOOL successed = NO;
    
    NSArray *objectArray = [[FMDBManager shareManager] queryRecordInTable:kStrangeWordTable withConditionDictionary:@{kWord:word}];
    
    if([objectArray lastObject]){
        NSDictionary *wordRecordDict = [objectArray lastObject];
        
        NSInteger lookUpCount = [wordRecordDict getIntForKey:kLookUpCount];
        lookUpCount++;
        [wordRecordDict setValue:[NSNumber numberWithInteger:lookUpCount] forKey:kLookUpCount];
        
        NSDate *date = [NSDate currentDate];
        [wordRecordDict setValue:date forKey:kCreatDate];
        
        NSString *articlesAtring = [wordRecordDict getStringForKey:kArticles];
        NSArray *articles = [articlesAtring arrayWithJsonString:articlesAtring];
        if (![articles containsObject:articleName]) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:articles];
            [tempArray addObject:articleName];
            articlesAtring = [tempArray arrayToJsonString];
            [wordRecordDict setValue:articlesAtring forKey:kArticles];
        }
        
        successed = [[FMDBManager shareManager] updateRecordWithDictionary:wordRecordDict
                                                                   inTable:kStrangeWordTable
                                                   withConditionDictionary:@{kWord:word}];
    } else {
        NSString *wordText = word;
        NSDate *creatDate = [NSDate currentDate];
        NSString *chineseWord = [NSString string];
        NSString *firstUpperLetter = [[word substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        NSInteger lookUpCount= 1;
        NSArray *articles = [NSArray arrayWithObjects:articleName, nil];
        NSString *articlesString = [articles arrayToJsonString];
        
        NSDictionary *dict = @{@"word": wordText,
                               @"creatDate": creatDate,
                               @"chineseWord": chineseWord,
                               @"firstUpperLetter": firstUpperLetter,
                               @"lookUpCount": [NSNumber numberWithInteger:lookUpCount],
                               @"articles":articlesString};
        successed = [[FMDBManager shareManager] insertRecordWithDictionary:dict toTable:kStrangeWordTable];
    }
    
    return successed;
}

//删除一个单词
- (BOOL)deleteWord:(NSString *)word {
    BOOL successed = NO;
    
    return successed;
}

//改一个单词的信息
- (BOOL)updateWord:(NSString *)word {
    BOOL successed = NO;
    
    return successed;
}

//查询一个单词
- (BOOL)queryWordWithValue:(NSString *)value forKey:(NSString *)key {
    BOOL successed = NO;
    
    return successed;
}

@end
