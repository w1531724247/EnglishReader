//
//  WebDetailViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/12.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "WebDetailViewController.h"

@interface WebDetailViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"demoText" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.wrapWords(%@)", self.webView]];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    
    return _webView;
}

@end
