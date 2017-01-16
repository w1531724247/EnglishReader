//
//  WebDetailViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/12.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "WebViewDetailController.h"
#import "UIWebView+Category.h"
#import "UIWebViewJSDelegate.h"
#import "InterpreterView.h"
#import "StrangeWordTable.h"

@interface WebViewDetailController ()<UIWebViewJSProtocol>

@property (nonatomic, strong) UIWebViewJSDelegate *webViewJSDelegate;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL setuped;

@end

@implementation WebViewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)setupWebView {
    self.filePath = [self.filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//添加对中文文件路径以及文件名中包含空格的支持
    NSURL *url = [NSURL URLWithString:self.filePath];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    [self.view insertSubview:self.webView atIndex:0];
    self.webView.frame = self.view.bounds;
}

#pragma mark ----- InterpreterViewDelegate
- (void)interpreterView:(InterpreterView *)interpreterView closeButtonDidTouch:(id)sender {
    [self hiddenInterpreterView];
}

#pragma mark ---- UIWebViewJSProtocol
- (void)webViewTextDidTouch:(NSString *)text {
    NSString *articleName = [self.filePath lastPathComponent];
    [[StrangeWordTable shareTable] addWord:text withArticleName:articleName];
    [self showInterpreterViewWithText:text];
}

#pragma mark ----- getter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self.webViewJSDelegate;
    }
    
    return _webView;
}

- (UIWebViewJSDelegate *)webViewJSDelegate {
    if (!_webViewJSDelegate) {
        _webViewJSDelegate = [[UIWebViewJSDelegate alloc] init];
        _webViewJSDelegate.delegate = self;
    }
    
    return _webViewJSDelegate;
}
@end
