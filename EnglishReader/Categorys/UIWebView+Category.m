//
//  UIWebView+Category.m
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "UIWebView+Category.h"
#import "CommonDefines.h"
#import <objc/runtime.h>

@implementation UIWebView (Category)

//获取当前webView加载的URL
- (NSString *)URL {
    NSString *currentURL = [self stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
    return currentURL;
}

//获取当前webView的title
- (NSString *)title {
    NSString *title = [self stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    return title;
}

//获取当前webView的HTML文本
- (NSString *)HTMLString {
    NSString *html = [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    
    return html;
}

//获取当前webView上显示的文本bodyText
- (NSString *)bodyText {
    NSString *bodyText = [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"];//获取网页内容文字
    
    return bodyText;
}
    
//获取当前webView上显示的文本bodyHTML
- (NSString *)bodyHTML {
    NSString *bodyHTML = [self stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];//获取网页HTML文字
    
    return bodyHTML;
}
    
//替换webView的bodyHTML内容
- (void)replaceBodyHTML:(NSString *)newBodyHTML {
    NSString *result = [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.innerHTML = '%@'", newBodyHTML]];
    
}
    
//为webView的单词添加点击事件
- (void)actionWebView {
    NSError *error;
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"actionDocset" ofType:@"js"] encoding:NSUTF8StringEncoding error:&error]];
}

//分割每一个单词
- (void)seperatWords {
    [self stringByEvaluatingJavaScriptFromString:@"function wrapWords(element) {\
     var html = element.innerHTML;\
     var words = html.split(/ /);\
     var newHtml = '';\
     for (var i = 0; i < words.length; i++) {\
     newHtml += '<span>' + words[i] + '</span> ';\
     }\
     element.innerHTML = newHtml;\
     }"];
}


- (void)loadReferenceHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:string, @"html", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadReferenceHTMLString" object:nil userInfo:userInfo];
}

- (void)hookLoadHTMLStringMethod {
    Class class = [UIWebView class];
    Method originalMethod = class_getInstanceMethod(class, @selector(loadHTMLString:baseURL:));
    Method newMethod = class_getInstanceMethod(class, @selector(loadReferenceHTMLString:baseURL:));
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)restoreLoadHTMLStringMethod {
    Class class = [UIWebView class];
    Method originalMethod = class_getInstanceMethod(class, @selector(loadHTMLString:baseURL:));
    Method newMethod = class_getInstanceMethod(class, @selector(loadReferenceHTMLString:baseURL:));
    method_exchangeImplementations(newMethod, originalMethod);
}

@end
