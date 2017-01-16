//
//  UIWebViewJSDelegate.m
//  EnglishReader
//
//  Created by QMTV on 17/1/16.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "UIWebViewJSDelegate.h"
#import "UIWebView+Category.h"

@interface UIWebViewJSDelegate ()

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, assign) BOOL handled;

@end

@implementation UIWebViewJSDelegate

#pragma mark --------UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (!self.handled) {
        NSError *error;
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"actionSpan" ofType:@"js"] encoding:NSUTF8StringEncoding error:&error]];
        self.handled = YES;
    }
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"jsActionDelegate"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"error：%@", exceptionValue);
    };
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    [QMHUD showText:@"网络异常,请检查网络连接"];
}

#pragma mark ------- JSObjectProtocol
- (void)textDidTouch:(NSString *)text {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(webViewTextDidTouch:)]) {
            [weakSelf.delegate webViewTextDidTouch:text];
        }
    });
}



@end
