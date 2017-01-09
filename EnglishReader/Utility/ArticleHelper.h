//
//  ArticleHelper.h
//  EnglishReader
//
//  Created by QMTV on 17/1/7.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ArticleHelperDelegate;

@interface ArticleHelper : NSObject

@property (nonatomic, weak) id<ArticleHelperDelegate> delegate;
//处理文件
- (void)handleFileWithPath:(NSString *)filePath;

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

