//
//  ArticleHelper.h
//  EnglishReader
//
//  Created by QMTV on 17/1/7.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKDocReader.h"

@protocol ArticleHelperDelegate;

@interface ArticleHelper : NSObject

@property (nonatomic, strong) WKDocReader *docReader;
@property (nonatomic, weak) id<ArticleHelperDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger totalPage;//总页数
@property (nonatomic, assign, readonly) NSInteger currentPage;//总页数

//处理文件
- (void)handleFileWithPath:(NSString *)filePath;
//获取page页的文本
- (NSAttributedString *)actionTextWithPage:(NSInteger)page;

@end

@protocol ArticleHelperDelegate <NSObject>

//处理成功后的回调
- (void)articleHelper:(ArticleHelper *)helper handleSuccessedWithActionText:(NSAttributedString *)actionText;

@optional
//处理失败后的回调
- (void)articleHelper:(ArticleHelper *)helper handleFailureWithError:(NSError *)error;
//文本被点击后的回调
- (void)articleHelper:(ArticleHelper *)helper textDidTouch:(NSString *)text;

@end

