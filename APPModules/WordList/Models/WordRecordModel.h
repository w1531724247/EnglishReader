//
//  WordModel.h
//  EnglishReader
//
//  Created by QMTV on 17/1/10.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordRecordModel : NSObject

@property (nonatomic, copy) NSString *word;//单词
@property (nonatomic, copy) NSString *creatDate;//创建<添加>日期
@property (nonatomic, copy) NSString *chineseWord;//中文意思
@property (nonatomic, copy) NSString *firstUpperLetter;//首字母大写
@property (nonatomic, assign) NSInteger lookUpCount;//查看翻译的次数
@property (nonatomic, strong) NSArray<__kindof NSString *> *articles;//文章名数组<在...文章中点击过>

@end
