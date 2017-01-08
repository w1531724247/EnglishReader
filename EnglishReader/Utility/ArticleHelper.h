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
- (NSAttributedString *)analyseArticleWithFilePath:(NSString *)filePath;

@end

@protocol ArticleHelperDelegate <NSObject>
@optional
- (void)articleHelper:(ArticleHelper *)helper textDidTouch:(NSString *)text;

@end

