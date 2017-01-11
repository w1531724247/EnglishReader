//
//  InterpreterView.m
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//


#import "CommonDefines.h"
#import "InterpreterViewLocal.h"
#import "YYKit.h"
#import <UIKit/UIReferenceLibraryViewController.h>
#import "UIWebView+Category.h"

@interface InterpreterViewLocal ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIReferenceLibraryViewController *reference;

@end

@implementation InterpreterViewLocal

- (void)dealloc {
    [_webView restoreLoadHTMLStringMethod];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self.webView hookLoadHTMLStringMethod];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReferenceHTMLString:) name:kLoadReferenceHTMLString object:nil];
        
        [self addSubview:self.webView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.webView.frame = self.bounds;
    self.webView.backgroundColor = [UIColor whiteColor];
}

- (void)interpretWithText:(NSString *)text {
    if (self.reference) {
        [self.reference.view removeFromSuperview];
        self.reference = nil;
    }
    
    self.reference = [[UIReferenceLibraryViewController alloc] initWithTerm:text];
    [self insertSubview:self.reference.view belowSubview:self.webView];
}

#pragma mark ---- Notification

- (void)loadReferenceHTMLString:(NSNotification *)notification
{
    NSString *html = [notification.userInfo objectForKey:@"html"];
    [self.webView loadReferenceHTMLString:html baseURL:nil];
    
    if ([self.delegate respondsToSelector:@selector(interpreterSuccessed)]) {
        [self.delegate interpreterSuccessed];
    }
}

#pragma mark ---- getter

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    
    return _webView;
}

@end
