//
//  UIWebView+Category.h
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Category)

//获取当前webView加载的URL
- (NSString *)URL;
//获取当前webView的title
- (NSString *)title;
//获取当前webView的HTML文本
- (NSString *)HTMLString;
//获取当前webView上显示的文本bodyText
- (NSString *)bodyText;
//分割每一个单词
- (void)seperatWords;

- (void)loadReferenceHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

- (void)hookLoadHTMLStringMethod;

- (void)restoreLoadHTMLStringMethod;

@end
