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
#import "NSString+Category.h"
#import "StrangeWordTable.h"
#import "NSObject+RunTime.h"
#import "UITextView+Method.h"

@interface InterpreterViewLocal ()

@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UIReferenceLibraryViewController *reference;
@property (nonatomic, copy) NSString *currentString;
@property (nonatomic, assign) BOOL notFirstSet;

@end

@implementation InterpreterViewLocal

- (void)dealloc {
    [[[UITextView alloc] init] restoreSetAttributeText];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [[[UITextView alloc] init] hookSetAttributeText];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewSetAttributedText:) name:@"textViewAttributedText" object:nil];
        
        [self addSubview:self.textView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textView.frame = self.bounds;
    self.textView.backgroundColor = [UIColor whiteColor];
}

- (void)interpretWithText:(NSString *)text {
    self.notFirstSet = NO;
    
    if (self.reference) {
        [self.reference.view removeFromSuperview];
        self.reference = nil;
    }
    self.currentString = text;
    self.reference = [[UIReferenceLibraryViewController alloc] initWithTerm:text];
    [self insertSubview:self.reference.view belowSubview:self.textView];
    if ([self.delegate respondsToSelector:@selector(interpreterSuccessed)]) {
        [self.delegate interpreterSuccessed];
    }
}

#pragma mark ---- Notification

- (void)textViewSetAttributedText:(NSNotification *)notification
{
    if (self.notFirstSet) {
        return;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    NSAttributedString *attributedText = [userInfo valueForKey:@"attributedText"];
    [self.textView setAttributedText:attributedText];
    self.notFirstSet = YES;
    [self.textView scrollToTop];
}

#pragma mark ---- getter

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc] init];
        _textView.editable = NO;
        _textView.selectable = NO;
    }
    
    return _textView;
}

@end
