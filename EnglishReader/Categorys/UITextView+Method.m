//
//  UITextView+Method.m
//  Dash iOS
//
//  Created by QMTV on 2017/8/19.
//  Copyright © 2017年 Kapeli. All rights reserved.
//

#import "UITextView+Method.h"
#import <objc/runtime.h>

@implementation UITextView (Method)

- (void)setTextNew:(NSString *)text {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:text, @"text", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textViewText" object:nil userInfo:userInfo];
}

- (void)hookSetText {
    dispatch_async(dispatch_get_main_queue(), ^{
        Class class = [UITextView class];
        Method originalMethod = class_getInstanceMethod(class, @selector(setText:));
        Method newMethod = class_getInstanceMethod(class, @selector(setTextNew:));
        method_exchangeImplementations(originalMethod, newMethod);
    });
}

- (void)restoreSetText {
    dispatch_async(dispatch_get_main_queue(), ^{
        Class class = [UITextView class];
        Method originalMethod = class_getInstanceMethod(class, @selector(setText:));
        Method newMethod = class_getInstanceMethod(class, @selector(setTextNew:));
        method_exchangeImplementations(newMethod, originalMethod);
    });
}

- (void)setAttributeTextNew:(NSAttributedString *)attributedText {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:attributedText, @"attributedText", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textViewAttributedText" object:nil userInfo:userInfo];
}

- (void)hookSetAttributeText {
    dispatch_async(dispatch_get_main_queue(), ^{
        Class class = [UITextView class];
        Method originalMethod = class_getInstanceMethod(class, @selector(setAttributedText:));
        Method newMethod = class_getInstanceMethod(class, @selector(setAttributeTextNew:));
        method_exchangeImplementations(originalMethod, newMethod);
    });
}

- (void)restoreSetAttributeText {
    dispatch_async(dispatch_get_main_queue(), ^{
        Class class = [UITextView class];
        Method originalMethod = class_getInstanceMethod(class, @selector(setAttributedText:));
        Method newMethod = class_getInstanceMethod(class, @selector(setAttributeTextNew:));
        method_exchangeImplementations(newMethod, originalMethod);
    });
}

@end
