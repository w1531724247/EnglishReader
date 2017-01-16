//
//  ArticleDetailViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/7.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "TextViewDetailController.h"
#import "ArticleHelper.h"
#import "ArticleTextView.h"

#import <CoreText/CoreText.h>
#import "MJRefresh.h"
#import "StrangeWordTable.h"

@interface TextViewDetailController ()<ArticleHelperDelegate>

@property (nonatomic, strong) ArticleHelper *articleHleper;
@property (nonatomic, strong) ArticleTextView *textView;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation TextViewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubViews];
    [self.articleHleper handleFileWithPath:self.filePath];
}

- (void)setupSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.textView atIndex:0];
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
    NSString *articleName = [self.filePath lastPathComponent];
    [[StrangeWordTable shareTable] addWord:text withArticleName:articleName];
    [self showInterpreterViewWithText:text];
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

@end
