//
//  WordDetailViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "WordDetailViewController.h"
#import "UIWebView+Category.h"
#import <UIKit/UIReferenceLibraryViewController.h>
#import "CommonDefines.h"

@interface WordDetailViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIReferenceLibraryViewController *reference;

@end

@implementation WordDetailViewController

- (void)dealloc {
    [_webView restoreLoadHTMLStringMethod];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithWord:(NSString *)word {
    self = [super init];
    if (self) {
        self.word = word;
        self.title = word;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReferenceHTMLString:) name:kLoadReferenceHTMLString object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webView hookLoadHTMLStringMethod];
    [self.view addSubview:self.webView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.reference) {
        [self setupReferenceView];
    }
}

- (void)setupReferenceView {
    if (self.reference) {
        [self.reference.view removeFromSuperview];
        self.reference = nil;
    }
    
    self.reference = [[UIReferenceLibraryViewController alloc] initWithTerm:self.word];
    [self.view insertSubview:self.reference.view belowSubview:self.webView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

#pragma mark ---- notification

#pragma mark ---- Notification
- (void)loadReferenceHTMLString:(NSNotification *)notification
{
    NSString *html = [notification.userInfo objectForKey:@"html"];
    [self.webView loadReferenceHTMLString:html baseURL:nil];
}

#pragma mark ---- getter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    
    return _webView;
}

@end
