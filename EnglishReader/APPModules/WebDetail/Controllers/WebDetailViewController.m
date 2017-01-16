//
//  WebDetailViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/12.
//  Copyright © 2017年 LFC. All rights reserved.
//
#define kWebViewHeight 250.0

#import "WebDetailViewController.h"
#import "UIWebView+Category.h"
#import "UIWebViewJSDelegate.h"
#import "InterpreterView.h"
#import "StrangeWordTable.h"

@interface WebDetailViewController ()<UIWebViewDelegate, UIWebViewJSProtocol, InterpreterViewDelegate>
@property (nonatomic, strong) UIWebViewJSDelegate *webViewJSDelegate;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) InterpreterView *interpreterView;

@end

@implementation WebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [[self.urlString stringByDeletingPathExtension] lastPathComponent];
    
    [self setupWebView];
    [self hiddenInterpreterView];
}

- (void)setupWebView {
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:urlRequest];
}

#pragma mark ----- InterpreterViewDelegate
- (void)interpreterView:(InterpreterView *)interpreterView closeButtonDidTouch:(id)sender {
    [self hiddenInterpreterView];
}

#pragma mark ----- private
-  (void)showInterpreterViewWithText:(NSString *)text {
    [self.interpreterView startLoadingAnimation];
    
    CGFloat interpreterViewX = 0.0;
    CGFloat interpreterViewY = CGRectGetHeight(self.view.frame) - kWebViewHeight;
    CGFloat interpreterViewW = CGRectGetWidth(self.view.frame);
    CGFloat interpreterViewH = kWebViewHeight;
    CGRect frame = CGRectMake(interpreterViewX, interpreterViewY, interpreterViewW, interpreterViewH);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.interpreterView.frame = frame;
    } completion:^(BOOL finished) {
        [self.interpreterView interpretWithText:text];
    }];
}

- (void)hiddenInterpreterView {
    CGFloat interpreterViewX = 0.0;
    CGFloat interpreterViewY = CGRectGetHeight(self.view.frame);
    CGFloat interpreterViewW = CGRectGetWidth(self.view.frame);
    CGFloat interpreterViewH = kWebViewHeight;
    CGRect frame = CGRectMake(interpreterViewX, interpreterViewY, interpreterViewW, interpreterViewH);
    
    if (!_interpreterView) {
        [self.view addSubview:self.interpreterView];
        self.interpreterView.frame = frame;
    } else {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.interpreterView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark ---- UIWebViewJSProtocol

- (void)webViewTextDidTouch:(NSString *)text {
    NSString *articleName = [self.urlString lastPathComponent];
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

- (InterpreterView *)interpreterView {
    if (!_interpreterView) {
        _interpreterView = [[InterpreterView alloc] init];
        _interpreterView.delegate = self;
    }
    
    return _interpreterView;
}

@end
