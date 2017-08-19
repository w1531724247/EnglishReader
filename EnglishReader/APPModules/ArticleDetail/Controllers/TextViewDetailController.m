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
//    [self.articleHleper handleFileWithPath:self.filePath];
}

- (void)setupSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.textView atIndex:0];
    self.textView.frame = self.view.bounds;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"rtf"];
    NSAttributedString *attrStr = [[NSAttributedString alloc]
                                   initWithFileURL:url
                                   options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType}
                                   documentAttributes:nil error:nil];
    self.textView.attributedText = attrStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- ArticleHelperDelegate
- (void)articleHelper:(ArticleHelper *)helper handleSuccessedWithActionText:(NSAttributedString *)actionText {
//  用HTML创建attributed String
    
}

- (void)articleHelper:(ArticleHelper *)helper textDidTouch:(NSString *)text {
    NSString *articleName = [self.filePath lastPathComponent];
    
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    char lastChar = [text characterAtIndex:text.length-1];
    if((lastChar >= 'a' && lastChar <= 'z')||(lastChar >= 'A' && lastChar <= 'Z')){//是英文字母。
    
    } else {
        text = [text substringToIndex:text.length-1];
    }
    
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
