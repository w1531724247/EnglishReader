//
//  ArticleDetailViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/7.
//  Copyright © 2017年 LFC. All rights reserved.
//

#define kWebViewHeight 200.0

#import "ArticleDetailViewController.h"
#import "ArticleHelper.h"
#import "ArticleTextView.h"
#import "InterpreterViewLocal.h"
#import "InterpreterViewNetwork.h"
#import <UIKit/UIReferenceLibraryViewController.h>

@interface ArticleDetailViewController ()<ArticleHelperDelegate>

@property (nonatomic, strong) ArticleHelper *articleHleper;
@property (nonatomic, strong) ArticleTextView *textView;
@property (nonatomic, strong) InterpreterViewNetwork *interpreterViewNet;
@property (nonatomic, strong) InterpreterViewLocal *interpreterViewLocal;
@property (nonatomic, strong) UIView *interpreterView;

@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    self.textView.frame = self.view.bounds;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demoText" ofType:@"txt"];
    self.textView.attributedText = [self.articleHleper analyseArticleWithFilePath:filePath];
    
    [self setupInterpreterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- delegate
- (void)articleHelper:(ArticleHelper *)helper textDidTouch:(NSString *)text {
    if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:text]) {
        [self.interpreterViewLocal interpretWithText:text];
        self.interpreterView = self.interpreterViewLocal;
    } else {
        [self.interpreterViewNet interpretWithText:text];
        self.interpreterView = self.interpreterViewNet;
    }

    [self showInterpreterView];
}

#pragma mark ----- private

-  (void)showInterpreterView {
    [self setupInterpreterView];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat interpreterViewH = kWebViewHeight;
        CGFloat interpreterViewX = 0.0;
        CGFloat interpreterViewY = CGRectGetHeight(self.view.frame) - interpreterViewH;
        CGFloat interpreterViewW = CGRectGetWidth(self.view.frame);
        self.interpreterView.frame = CGRectMake(interpreterViewX, interpreterViewY, interpreterViewW, interpreterViewH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setupInterpreterView {
    if (!_interpreterViewLocal) {
        [self.view addSubview:self.interpreterViewLocal];
    }
    
    if (!_interpreterViewNet) {
        [self.view addSubview:self.interpreterViewNet];
    }
    
    CGFloat interpreterViewX = 0.0;
    CGFloat interpreterViewY = CGRectGetHeight(self.view.frame);
    CGFloat interpreterViewW = CGRectGetWidth(self.view.frame);
    CGFloat interpreterViewH = kWebViewHeight;
    self.interpreterViewLocal.frame = self.interpreterViewNet.frame = CGRectMake(interpreterViewX, interpreterViewY, interpreterViewW, interpreterViewH);
}

#pragma mark ----- getter

- (ArticleHelper *)articleHleper {
    if (!_articleHleper) {
        _articleHleper = [[ArticleHelper alloc] init];
        _articleHleper.delegate = self;
    }
    
    return _articleHleper;
}

- (ArticleTextView *)textView {
    if (!_textView) {
        _textView = [[ArticleTextView alloc] init];
    }
    
    return _textView;
}

- (InterpreterViewNetwork *)interpreterViewNet {
    if (!_interpreterViewNet) {
        _interpreterViewNet = [[InterpreterViewNetwork alloc] init];
    }
    
    return _interpreterViewNet;
}

- (InterpreterViewLocal *)interpreterViewLocal {
    if (!_interpreterViewLocal) {
        _interpreterViewLocal = [[InterpreterViewLocal alloc] init];
    }
    
    return _interpreterViewLocal;
}

@end
