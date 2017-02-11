//
//  UIWebViewJSDelegate.h
//  EnglishReader
//
//  Created by QMTV on 17/1/16.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSObjectProtocol.h"

@protocol UIWebViewJSProtocol;
@interface UIWebViewJSDelegate : NSObject<UIWebViewDelegate, JSObjectProtocol>

@property (nonatomic, weak) id<UIWebViewJSProtocol> delegate;

@end

@protocol UIWebViewJSProtocol <NSObject>

- (void)webViewTextDidTouch:(NSString *)text;
- (void)jsHandleCompleted;

@end
