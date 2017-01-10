//
//  ArticleDetailViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/7.
//  Copyright © 2017年 LFC. All rights reserved.
//

#define kWebViewHeight 250.0

#import "ArticleDetailViewController.h"
#import "ArticleHelper.h"
#import "ArticleTextView.h"
#import "InterpreterView.h"
#import <CoreText/CoreText.h>
#import "MJRefresh.h"

@interface ArticleDetailViewController ()<ArticleHelperDelegate, InterpreterViewDelegate>

@property (nonatomic, strong) ArticleHelper *articleHleper;
@property (nonatomic, strong) ArticleTextView *textView;
@property (nonatomic, strong) InterpreterView *interpreterView;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [[self.filePath stringByDeletingPathExtension] lastPathComponent];
    [self setupSubViews];
    [self.articleHleper handleFileWithPath:self.filePath];
    [self hiddenInterpreterView];
}

- (void)setupSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    self.textView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- ArticleHelperDelegate
- (void)articleHelper:(ArticleHelper *)helper handleSuccessedWithActionText:(NSAttributedString *)actionText {
    self.textView.attributedText = actionText;
}

- (void)articleHelper:(ArticleHelper *)helper textDidTouch:(NSString *)text {
    [self showInterpreterViewWithText:text];
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

#pragma mark --- refresh action
- (void)showPreviousPageText:(id)sender {
    self.currentPage--;
    if (self.currentPage <= 0) {
        self.currentPage = 0;
    }

    self.textView.attributedText = [self.articleHleper actionTextWithPage:self.currentPage];
    [self.textView.mj_header endRefreshing];
}

- (void)showNextPageText:(id)sender {
    self.currentPage++;
    if (self.currentPage >= self.articleHleper.totalPage) {
        self.currentPage--;
        [self.textView.mj_footer resetNoMoreData];
        return;
    }
    
    self.textView.attributedText = [self.articleHleper actionTextWithPage:self.currentPage];
    [self.textView scrollToTopAnimated:NO];
    [self.textView.mj_footer endRefreshing];
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
        _textView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(showPreviousPageText:)];
        _textView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(showNextPageText:)];
    }
    
    return _textView;
}

- (InterpreterView *)interpreterView {
    if (!_interpreterView) {
        _interpreterView = [[InterpreterView alloc] init];
        _interpreterView.delegate = self;
    }
    
    return _interpreterView;
}

@end