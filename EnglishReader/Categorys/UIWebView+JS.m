//
//  UIWebView+JS.m
//  EnglishReader
//
//  Created by QMTV on 17/1/9.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "UIWebView+JS.h"

@implementation UIWebView (JS)

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

@end
