//
//  ArticleHelper.m
//  EnglishReader
//
//  Created by QMTV on 17/1/7.
//  Copyright © 2017年 LFC. All rights reserved.
//

#define kMaxWords 1000

#import "ArticleHelper.h"
#import <ctype.h>
#import "YYKit.h"
#import "UIWebView+JS.h"
#import <TET_ios/TET_objc.h>
#import "UIManager.h"

@interface ArticleHelper ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign, readwrite) NSInteger totalPage;//总页数
@property (nonatomic, assign, readwrite) NSInteger currentPage;//总页数
@property (nonatomic, strong) NSMutableArray *pageOfText;//每1万个字符为一页, 每一页为一个元素

@end

@implementation ArticleHelper

#pragma amrk ------ public

- (void)handleFileWithPath:(NSString *)filePath {
    if (filePath.length < 1 || ![filePath isKindOfClass:[NSString class]]) {
        return ;
    }

    // 获得文件的后缀名（不带'.'）
    NSString *fileExtension = [filePath pathExtension];
    if ([fileExtension isEqualToString:@"txt"]) {
        [self handleTxtWithFilePath:filePath];
    }
    
    if ([fileExtension isEqualToString:@"docx"]) {
        [self handleMSWordWithFilePath:filePath];
    }
    
    if ([fileExtension isEqualToString:@"doc"]) {
        [self handleMSWordWithFilePath:filePath];
    }
    
    if ([fileExtension isEqualToString:@"rtf"]) {
        [self handleRTFTextWithFilePath:filePath];
    }
    
    if ([fileExtension isEqualToString:@"html"]) {
        [self handleHTMLStringWithFilePath:filePath];
    }
    
    if ([fileExtension isEqualToString:@"pdf"]) {
        [self handlePDFWithFilePath:filePath];
    }
}

//获取page页的文本
- (NSAttributedString *)actionTextWithPage:(NSInteger)page {
    if (page > self.totalPage - 1) {
        return [[NSAttributedString alloc] init];
    }
    
    NSAttributedString *attributedText = [self.pageOfText objectAtIndex:page];
    
    return [self addActionToAttributedText:attributedText];
}


#pragma amrk ------ private
//处理txt文本
- (void)handleTxtWithFilePath:(NSString *)filePath {
    NSError *error;
    NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        if ([self.delegate respondsToSelector:@selector(articleHelper:handleFailureWithError:)]) {
            [self.delegate articleHelper:self handleFailureWithError:error];
        }
        
        return;
    }

    [self handleText:text];
}

//处理Mircosoft word.docx文档
- (void)handleMSWordWithFilePath:(NSString *)filePath {
    NSURL *url = [NSURL URLWithString:filePath];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:urlRequest];
}

//处理rtf文本
- (void)handleRTFTextWithFilePath:(NSString *)filePath {
    //rtf--to--NSAttributedString
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    //UILabel显示HTML文本
    NSDictionary *docAttributes = [NSDictionary dictionary];
    NSError *error;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:data
                                                                       options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType}
                                                            documentAttributes:&docAttributes
                                                                         error:&error];
    [self handleAttributedText:attrStr];

    /*NSAttributedString--rtf--to
     NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"YOLO" attributes:nil];
     NSData *data = [str dataFromRange:(NSRange){0, [str length]} documentAttributes:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} error:NULL];
     [data writeToFile:@"/me.rtf" atomically:YES];
     */
}

//处理html文本
- (void)handleHTMLStringWithFilePath:(NSString *)filePath {
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    //UILabel显示HTML文本
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
}

//处理pdf文本
- (void)handlePDFWithFilePath:(NSString *)filePath {
    NSString *pdfContent = [self extractTextFromPDFWithFilePath:filePath];
    [self handleText:pdfContent];
}

- (NSArray *)analyseArticleText:(NSString *)articleText {
    if (![articleText isKindOfClass:[NSString class]]) {
        return [NSArray array];
    }
    
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSInteger length = articleText.length;
    for (int i = 0; i < length; i++) {//遍历每一个字符串, 判断它的类型
        char character = [articleText characterAtIndex:i];
        
        if (isspace(character)) {//判断字符c是否为空白符, 空白符指空格、水平制表、垂直制表、换页、回车和换行符。
            for (int j = i; j < length; j++) {
                character = [articleText characterAtIndex:j];
                if (!isspace(character)) {
                    break;//某一段空白符遍历完了
                }
            }
            
            continue;
        }
        
        if (isdigit(character)) {//判断字符c是否为数字
            for (int j = i; j < length; j++) {
                character = [articleText characterAtIndex:j];
                if (!isdigit(character)) {
                    break;//某一段数字遍历完了
                }
            }
            
            continue;
        }
        
        if (isalpha(character)) {//判断字符c是否为英文字母
            for (int j = i; j < length; j++) {
                character = [articleText characterAtIndex:j];
                if (!isalpha(character)) {
                    NSString *smpStr = [NSString stringWithUTF8String:"’"];
                    NSString *currentString = [articleText substringWithRange:NSMakeRange(j, 1)];
                    if (![currentString isEqualToString:smpStr]) {
                        NSRange range = NSMakeRange(i, j-i);
                        [rangeArray addObject:[NSValue valueWithRange:range]];
                        i = j;
                        break;//某一段字母遍历完了
                    }
                }
            }
            
            continue;
        }
        
        if (ispunct(character)) {//判断字符c是否为标点符号
            for (int j = i; j < length; j++) {
                character = [articleText characterAtIndex:j];
                if (!ispunct(character)) {
                    break;//某一段标点符号遍历完了
                }
            }
        
            continue;
        }
    }
    
    return [NSArray arrayWithArray:rangeArray];
}

- (void)handleText:(NSString *)text {
    if (text.length < 1 || ![text isKindOfClass:[NSString class]]) {
        return ;
    }
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text];
    [self handleAttributedText:attributedText];
}

- (void)actionTextWithAttributedText:(NSAttributedString *)text {
    if (text.length < 1 || ![text isKindOfClass:[NSString class]]) {
        return;
    }
    
    [self handleAttributedText:text];
}

- (void)handleAttributedText:(NSAttributedString *)attributedText {
    NSArray *rangeArray = [self analyseArticleText:attributedText.string];
    NSInteger realPage = [self pagingArray:rangeArray];//单词分页, 每kMaxWords个单词为一页
    
    for (int page = 0; page < realPage; page++) {
        NSInteger location = page*kMaxWords;
        NSArray *subRange;
        NSRange pageRange = NSMakeRange(location, kMaxWords);
        
        if ((pageRange.location + pageRange.length) > rangeArray.count) {//最后一页, 不足千个单词
            pageRange = NSMakeRange(location, rangeArray.count - location);
        }
        
        subRange = [rangeArray subarrayWithRange:pageRange];
        NSRange startRange = [[subRange firstObject] rangeValue];
        NSRange endRange = [[subRange lastObject] rangeValue];
        
        NSRange pageStringRange;
        if (page == 0) {//第一页
            pageStringRange = NSMakeRange(0, endRange.location + endRange.length);
        } else if (page == (realPage - 1)) {//最后一页
            pageStringRange = NSMakeRange(startRange.location, attributedText.string.length - startRange.location);
        } else {//中间页
            pageStringRange = NSMakeRange(startRange.location, endRange.location + endRange.length - startRange.location);
        }
        
        NSAttributedString *actionText = [[NSMutableAttributedString alloc] initWithAttributedString:[attributedText attributedSubstringFromRange:pageStringRange]];
        
        [self.pageOfText addObject:actionText];
    }

    if ([self.delegate respondsToSelector:@selector(articleHelper:handleSuccessedWithActionText:)]) {
        [self.delegate articleHelper:self handleSuccessedWithActionText:[self actionTextWithPage:0]];
    }
}

- (NSInteger)pagingArray:(NSArray *)rangeArray {
    CGFloat totalPage = rangeArray.count*1.0/kMaxWords;
    NSInteger realPage = totalPage;
    if (totalPage > 1 && totalPage > realPage) {//大于一页, 不足整页
        realPage = realPage+1;
    } else if (totalPage < 1 && totalPage > 0) {//不到一页
        realPage = 1;
    } else {//大于一页, 并且是整页
        realPage = realPage;
    }
    
    return realPage;
}

- (NSAttributedString *)addActionToAttributedText:(NSAttributedString *)attributedText {
    NSMutableAttributedString *actionText = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    NSArray *rangeArray = [self analyseArticleText:attributedText.string];
    
    __weak typeof(self) weakSelf = self;
    for (int index = 0; index < rangeArray.count; index++) {
        NSValue *value = [rangeArray objectAtIndex:index];
        NSRange range = [value rangeValue];
        [actionText setTextHighlightRange:range
                                    color:[UIManager textColor]
                          backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                                tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                                    [weakSelf textDidTouch:[text attributedSubstringFromRange:range].string];
                                }];
    }
    
    [actionText addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:20.0],
                                }
                        range:NSMakeRange(0, actionText.string.length)];
    //    [attributedText setKern:[NSNumber numberWithFloat:1.0]];//设置字间距
    [actionText setLineSpacing:8.0];//设置行间距
    
    return actionText;
}


- (NSString *)extractTextFromPDFWithFilePath:(NSString *)filePath {
    
    // Find our documents directory
    NSArray *dirPaths;
    NSString *documentsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [dirPaths objectAtIndex:0];
    
    /* for simplicity we use hardcoded filenames */
    NSString *infile= filePath;
    
    /* global option list */
    NSString *globaloptlist =
    [NSString stringWithFormat:@"searchpath={{%@} {%@/EnglishReader.app} {%@/EnglishReader.app/resource/cmap}}",
     documentsDir, NSHomeDirectory(), NSHomeDirectory()];
    
    /* option list to switch on TET logging */
    //NSString *loggingoptlist = [NSString stringWithFormat:@"logging {filename={%@/trace.txt} remove}", documentsDir];
    
    /* document-specific option list */
    NSString *docoptlist = @"";
    
    /* page-specific option list */
    NSString *pageoptlist = @"granularity=page";
    
    /* separator to emit after each chunk of text. This depends on the
     * application's needs;
     * for granularity=word a space character may be useful.
     */
#define SEPARATOR @"\n"
    
    int pageno = 0;
    NSMutableString *pdfText = [[NSMutableString alloc]init];;
    NSString *warningText=@"";
    
    TET *tet = [[TET alloc] init];
    if (!tet) {
        return pdfText;
    }
    
    @try {
        NSInteger n_pages;
        NSInteger doc;
        
        //[tet set_option:loggingoptlist];
        [tet set_option:globaloptlist];
        
        doc = [tet open_document:infile optlist:docoptlist];
        
        if (doc == -1)
        {
            warningText = [NSString stringWithFormat:@"Error %ld in %@(): %@\n",
                           (long)[tet get_errnum], [tet get_apiname], [tet get_errmsg]];
            [self displayError:warningText];
            return pdfText;
        }
        
        /* get number of pages in the document */
        n_pages = (NSInteger) [tet pcos_get_number:doc path:@"length:pages"];
        
        /* loop over pages in the document */
        for (pageno = 1; pageno <= n_pages; ++pageno)
        {
            NSString *text;
            NSInteger page;
            
            page = [tet open_page:doc pagenumber:pageno optlist:pageoptlist];
            
            if (page == -1)
            {
                warningText = [NSString stringWithFormat:@"%@\nError %ld in %@() on page %d: %@\n",
                               warningText, (long)[tet get_errnum], [tet get_apiname], pageno, [tet get_errmsg]];
                continue;                        /* try next page */
            }
            
            /* Retrieve all text fragments; This is actually not required
             * for granularity=page, but must be used for other granularities.
             */
            while ((text = [tet get_text:page]) != nil)
            {
                [pdfText appendString:text];
                [pdfText appendString:SEPARATOR];
            }
            
            if ([tet get_errnum] != 0)
            {
                warningText  = [NSString stringWithFormat:@"%@\nError %ld in %@() on page %d: %@\n", warningText, (long)[tet get_errnum], [tet get_apiname], pageno, [tet get_errmsg]];
            }
            
            [tet close_page:page];
        }
        
        [tet close_document:doc];
    }
    
    @catch (TETException *ex) {
        NSString *exception=@"";
        if (pageno == 1) {
            exception = [NSString stringWithFormat:@"Error %ld in %@(): %@\n",
                         (long)[ex get_errnum], [ex get_apiname], [ex get_errmsg]];
        } else {
            exception = [NSString stringWithFormat:@"Error %ld in %@() on page %d: %@\n",
                         (long)[ex get_errnum], [ex get_apiname], pageno, [ex get_errmsg]];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TET crashed" message:exception
                                                           delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
    }
    @catch (NSException *ex) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[ex name] message:[ex reason]
                                                           delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    @finally {
        if (tet)
            tet = nil;
    }
    
    
    /* show the warning(s) that occured while processing the file */
    if (warningText.length>0) {
        [self displayError:warningText];
    }
    
    return pdfText;
}


- (void)displayError:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TET error" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertView show];
}

#pragma mark ----- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *bodyText = [webView bodyText];
    [self handleText:bodyText];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.webView];
//    self.webView.frame = [UIApplication sharedApplication].keyWindow.bounds;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(articleHelper:handleFailureWithError:)]) {
        [self.delegate articleHelper:self handleFailureWithError:error];
    }
}

#pragma mark ---- action
- (void)textDidTouch:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(articleHelper:textDidTouch:)]) {
        [self.delegate articleHelper:self textDidTouch:text];
    }
}

#pragma mark ----- getter

- (NSInteger)totalPage {
    return self.pageOfText.count;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
    }
    
    return _webView;
}

- (NSMutableArray *)pageOfText {
    if (!_pageOfText) {
        _pageOfText = [NSMutableArray array];
    }
    
    return _pageOfText;
}


@end
