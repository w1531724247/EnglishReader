//
//  UIWebView+JS.h
//  EnglishReader
//
//  Created by QMTV on 17/1/9.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JS)

//获取当前webView加载的URL
- (NSString *)URL;
//获取当前webView的title
- (NSString *)title;
//获取当前webView的HTML文本
- (NSString *)HTMLString;
//获取当前webView上显示的文本bodyText
- (NSString *)bodyText;

@end
