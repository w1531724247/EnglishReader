//
//  StrangeWordTable.h
//  EnglishReader
//
//  Created by QMTV on 17/1/10.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StrangeWordTable : NSObject
/**
 *  单例对象,你总是应该通过单例使用这个类
 *
 *  @return 单例
 */
+ (instancetype)shareTable;

//添加一个单词
- (BOOL)addWord:(NSString *)word withArticleName:(NSString *)articleName;
//删除一个单词
- (BOOL)deleteWord:(NSString *)word;

//改一个单词的中文翻译的信息
- (BOOL)updateWord:(NSString *)word withChineseInterpretation:(NSString *)interpretation;

//通过首字母查询单词列表
- (NSArray *)queryStrangeWordByFirstUpperLetter:(NSString *)firstUpperLetter;

@end
