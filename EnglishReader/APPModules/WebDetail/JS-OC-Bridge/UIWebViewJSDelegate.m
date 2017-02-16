//
//  UIWebViewJSDelegate.m
//  EnglishReader
//
//  Created by QMTV on 17/1/16.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "UIWebViewJSDelegate.h"
#import "UIWebView+Category.h"
#import "FileManager.h"

@interface UIWebViewJSDelegate ()

@property (nonatomic, strong) JSContext *jsContext;
    
@end

@implementation UIWebViewJSDelegate

#pragma mark --------UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"jsActionDelegate"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"error：%@", exceptionValue);
    };
    
    if ([self.delegate respondsToSelector:@selector(jsHandleCompleted)]) {
        [self.delegate jsHandleCompleted];
    }
}
    
- (void)actionWebView:(UIWebView *)webView {
    NSString *htmlString = [webView HTMLString];
    NSRange bodyStartRange = [htmlString rangeOfString:@"<body"];
    htmlString = [htmlString substringToIndex:bodyStartRange.location];
    htmlString = [NSString stringWithFormat:@"<html>%@<body>", htmlString];
    
    NSString *bodyHTML = [webView bodyHTML];
    //1.把body里所有的文本提取出来, 按顺序放在一个数组里
    NSString *newBodyHTML = @"";
    
    //2.找到第一个结束标签>的位置
    NSUInteger textStartIndex = [bodyHTML rangeOfString:@">"].location;
    textStartIndex = textStartIndex + 1;//标签结束的位置就是, 文本开始的位置
    
    newBodyHTML = [newBodyHTML stringByAppendingString:[bodyHTML substringWithRange:NSMakeRange(0, textStartIndex)]];
    NSString *remainString = [bodyHTML substringFromIndex:textStartIndex];
    
    do {
        NSUInteger textEndIndex = [remainString rangeOfString:@"<"].location;//闭合标签开始的位置就是文本结束的位置
        //获取闭合标签文本, 用来判断此标签类型
        NSUInteger closeFlagIndex = [remainString rangeOfString:@">"].location;
        NSString *closeTag = [remainString substringWithRange:NSMakeRange(textEndIndex, closeFlagIndex - textEndIndex + 1)];
        if ([self isExceptTag:closeTag]) {
            newBodyHTML = [newBodyHTML stringByAppendingString:[remainString substringWithRange:NSMakeRange(0, closeFlagIndex+1)]];
            remainString = [remainString substringFromIndex:closeFlagIndex+1];
            continue;
        }
        NSString *targetText = [remainString substringWithRange:NSMakeRange(0, textEndIndex)];
        
        if ([targetText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
        {
            newBodyHTML = [newBodyHTML stringByAppendingString:@"<span>"];
            newBodyHTML = [newBodyHTML stringByAppendingString:targetText];
            newBodyHTML = [newBodyHTML stringByAppendingString:@"</span>"];
        } else {
            newBodyHTML = [newBodyHTML stringByAppendingString:targetText];
        }
        
        newBodyHTML = [newBodyHTML stringByAppendingString:closeTag];
        
        textStartIndex = [remainString rangeOfString:@">"].location;
        textStartIndex = textStartIndex + 1;
        remainString = [remainString substringFromIndex:textStartIndex];
        
    } while([remainString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0);
    
    htmlString = [NSString stringWithFormat:@"%@%@</body></html>", htmlString, newBodyHTML];
    
    [FileManager creatDocumentSubDirectoryWithString:@"temp"];
    NSString *filePath = [[FileManager documentDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"temp/tempConvert.html"]];
    filePath = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//添加对中文文件路径以及文件名中包含空格的支持
    [htmlString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:filePath]]];
}

- (BOOL)isExceptTag:(NSString *)closeTag {
    BOOL isExcept = NO;
    NSArray *exceptTags = [NSArray arrayWithObjects:@"</script>", @"</a>", @"</table>", @"</caption>", @"</th>", @"</tr>", @"</td>", @"</thead>", @"</tbody>", @"</tfoot>", @"</col>", @"</colgroup>", @"</img>", nil];
    if ([[closeTag substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"<!"]) {//是注释
        isExcept = YES;
        return isExcept;
    }
    
    if ([exceptTags containsObject:closeTag]) {
        isExcept = YES;
    }
    
    return isExcept;
}
    
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

#pragma mark ------- JSObjectProtocol
- (void)textDidTouch:(NSString *)text {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(webViewTextDidTouch:)]) {
            [weakSelf.delegate webViewTextDidTouch:text];
        }
    });
}
    
@end
