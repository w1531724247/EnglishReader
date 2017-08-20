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
#import "UIWebView+Category.h"
#import "YYKit.h"
#import <TET_ios/TET_objc.h>
#import "UIManager.h"
#import "NSObject+Multithreading.h"

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
    filePath = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//添加对中文文件路径以及文件名中包含空格的支持
    if ([fileExtension isEqualToString:@"txt"]) {
        [self handleTxtWithFilePath:filePath];
    }
    
    if ([fileExtension isEqualToString:@"rtf"]) {
        [self handleRTFTextWithFilePath:filePath];
    }
    if ([fileExtension isEqualToString:@"rtfd"]) {
        [self handleRTFDTextWithFilePath:filePath];
    }
    
    if ([fileExtension isEqualToString:@"html"]) {
        [self handleHTMLStringWithFilePath:filePath];
    }
}

#pragma amrk ------ private
//处理txt文本
- (void)handleTxtWithFilePath:(NSString *)filePath {
    NSError *error;
    NSData *stringData = [NSData dataWithContentsOfFile:filePath];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:stringData options:@{NSDocumentTypeDocumentAttribute:NSPlainTextDocumentType} documentAttributes:nil error:&error];
    
    if (error) {
        if ([self.delegate respondsToSelector:@selector(articleHelper:handleFailureWithError:)]) {
            [self.delegate articleHelper:self handleFailureWithError:error];
        }
        
        return;
    }

    [self handleAttributedText:attributeString];
}


//处理rtf文本
- (void)handleRTFTextWithFilePath:(NSString *)filePath {
    NSError *error;
    NSData *stringData = [NSData dataWithContentsOfFile:filePath];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:stringData options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:&error];
    
    if (error) {
        if ([self.delegate respondsToSelector:@selector(articleHelper:handleFailureWithError:)]) {
            [self.delegate articleHelper:self handleFailureWithError:error];
        }
        
        return;
    }
    
    [self handleAttributedText:attributeString];
}

//处理rtfd文本
- (void)handleRTFDTextWithFilePath:(NSString *)filePath {
    NSError *error;
    NSData *stringData = [NSData dataWithContentsOfFile:filePath];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:stringData options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:&error];
    
    if (error) {
        if ([self.delegate respondsToSelector:@selector(articleHelper:handleFailureWithError:)]) {
            [self.delegate articleHelper:self handleFailureWithError:error];
        }
        
        return;
    }
    
    [self handleAttributedText:attributeString];
}

//处理html文本
- (void)handleHTMLStringWithFilePath:(NSString *)filePath {
    NSError *error;
    NSData *stringData = [NSData dataWithContentsOfFile:[filePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:stringData options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:&error];
    
    if (error) {
        if ([self.delegate respondsToSelector:@selector(articleHelper:handleFailureWithError:)]) {
            [self.delegate articleHelper:self handleFailureWithError:error];
        }
        
        return;
    }
    
    [self handleAttributedText:attributeString];
}

//处理pdf文本
- (void)handlePDFWithFilePath:(NSString *)filePath {
//    NSString *pdfContent = [self extractTextFromPDFWithFilePath:filePath];
//    [self handleAttributedText:pdfContent];
}

- (void)actionTextWithAttributedText:(NSAttributedString *)text {
    if (text.length < 1 || ![text isKindOfClass:[NSAttributedString class]]) {
        return;
    }
    
    [self handleAttributedText:text];
}

- (void)handleAttributedText:(NSAttributedString *)attributedText {
    __weak typeof(self) weakSelf = self;
    [self normalLogicOperation:^{
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
        NSString *abString = attString.string;
        NSInteger length = attString.length;
        
        NSMutableArray *rangeArray = [NSMutableArray array];
        NSMutableArray *notRangeArray = [NSMutableArray array];
        NSUInteger startIndex = 0;
        NSUInteger endIndex = 0;
        BOOL skipStartIndex = NO;
        BOOL skipAdd = NO;
        for (int index = 0; index < length; index++) {
            char substring = [abString characterAtIndex:index];
            if ((substring >= 'a' && substring <= 'z') || (substring >= 'A' && substring <= 'Z')) {
                if (!skipStartIndex) {
                    startIndex = index;
                    skipStartIndex = YES;
                    skipAdd = NO;
                }
            } else {
                endIndex = index;
                skipStartIndex = NO;
                if (!skipAdd) {
                    if (startIndex < endIndex) {
                        [rangeArray addObject:[NSValue valueWithRange:NSMakeRange(startIndex, endIndex-startIndex)]];
                        skipAdd = YES;
                    }
                }
                
                NSRange subRange = NSMakeRange(index, 1);
                NSAttributedString *subString = [attString attributedSubstringFromRange:subRange];
                NSMutableDictionary *attributed = [NSMutableDictionary dictionaryWithDictionary:[subString attributes]];
                [attributed setValue:[UIFont fontWithName:@"Menlo-Regular" size:20.0] forKey:NSFontAttributeName];
                [attString setAttributes:attributed range:subRange];
            }
        }
        
        for (NSValue *value in rangeArray) {
            NSRange subRange = [value rangeValue];
            NSAttributedString *subString = [attString attributedSubstringFromRange:subRange];
            UIFont *font = [subString font];
            CGFloat pointSize = [font pointSize];
            NSMutableDictionary *attributed = [NSMutableDictionary dictionaryWithDictionary:[subString attributes]];
            if (pointSize < 17.0) {
//       NSArray *fonts = [UIFont fontNamesForFamilyName:@"Menlo"];
                [attributed setValue:[UIFont fontWithName:@"Menlo-Regular" size:20.0] forKey:NSFontAttributeName];
                [attString setAttributes:attributed range:subRange];
            } else {
                [attributed setValue:[UIFont fontWithName:@"Menlo-Regular" size:pointSize] forKey:NSFontAttributeName];
                [attString setAttributes:attributed range:subRange];
            }
            
            [attString setTextHighlightRange:subRange color:nil backgroundColor:[UIColor blueColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                if ([weakSelf.delegate respondsToSelector:@selector(articleHelper:textDidTouch:)]) {
                    [weakSelf.delegate articleHelper:weakSelf textDidTouch:[text attributedSubstringFromRange:range].string];
                }
            }];
        }
        
        if ([weakSelf.delegate respondsToSelector:@selector(articleHelper:handleSuccessedWithActionText:)]) {
            [weakSelf.delegate articleHelper:self handleSuccessedWithActionText:attString];
        }
    }];
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

@end
