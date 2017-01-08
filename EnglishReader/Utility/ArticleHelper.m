//
//  ArticleHelper.m
//  EnglishReader
//
//  Created by QMTV on 17/1/7.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "ArticleHelper.h"
#import <ctype.h>
#import "YYKit.h"

@implementation ArticleHelper

#pragma amrk ------ public

- (NSAttributedString *)analyseArticleWithFilePath:(NSString *)filePath {
    NSError *error;
    NSString *articleText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"解析文章出错!");
    }
    NSArray *rangeArray = [self analyseArticleText:articleText];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:articleText];
    
    __weak typeof(self) weakSelf = self;
    for (NSValue *value in rangeArray) {
        NSRange range = [value rangeValue];
        [attributedText setTextHighlightRange:range
                             color:[UIColor blackColor]
                   backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             [weakSelf textDidTouch:[text attributedSubstringFromRange:range].string];
                         }];
    }
    
    [attributedText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                                    }
                            range:NSMakeRange(0, articleText.length)];
    [attributedText setKern:[NSNumber numberWithFloat:1.0]];//设置字间距
    [attributedText setLineSpacing:8.0];//设置行间距
    
    return attributedText;
}

#pragma amrk ------ private

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
                    i=j-1;
                    break;//某一段空白符遍历完了
                }
            }
        }
        
        if (isdigit(character)) {//判断字符c是否为数字
            for (int j = i; j < length; j++) {
                character = [articleText characterAtIndex:j];
                if (!isdigit(character)) {
                    i=j-1;
                    break;//某一段数字遍历完了
                }
            }
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
        }
        
        if (ispunct(character)) {//判断字符c是否为标点符号
            for (int j = i; j < length; j++) {
                character = [articleText characterAtIndex:j];
                if (!ispunct(character)) {
                    i=j-1;
                    break;//某一段标点符号遍历完了
                }
            }
        }
    }
    
    return [NSArray arrayWithArray:rangeArray];
}

#pragma mark ---- action
- (void)textDidTouch:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(articleHelper:textDidTouch:)]) {
        [self.delegate articleHelper:self textDidTouch:text];
    }
}

@end
