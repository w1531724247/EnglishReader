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
#import "UIWebView+Category.h"

@interface WebViewDetailController ()<UIWebViewJSProtocol>

@property (nonatomic, strong) UIWebViewJSDelegate *webViewJSDelegate;
@property (nonatomic, strong, readwrite) UIWebView *webView;
@property (nonatomic, assign) BOOL setuped;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation WebViewDetailController
    
- (void)dealloc {
    _webView = nil;
    _webViewJSDelegate = nil;

}

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
    self.webView.hidden = YES;
    
    [self.view addSubview:self.indicatorView];
    self.indicatorView.center = self.view.center;
    [self.indicatorView startAnimating];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(HTMLAddActionToEveryWord)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)HTMLAddActionToEveryWord {
    [self.webView actionWebView];
//    [self.webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
    
    
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

- (void)jsHandleCompleted {
    self.webView.hidden = NO;
    [self.indicatorView stopAnimating];
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

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.color = [UIColor darkGrayColor];
    }
    
    return _indicatorView;
}

@end
