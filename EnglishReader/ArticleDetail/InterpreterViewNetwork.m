//
//  InterpreterViewNetwork.m
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "InterpreterViewNetwork.h"
#import "APIManager.h"
#import "YYKit.h"
#import "NSDictionary+JSONHelper.h"

@interface InterpreterViewNetwork () <APIManagerProtocol>

@property (nonatomic, strong) APIManager *apiManager;
@property (nonatomic, strong) YYTextView *textView;

@end

@implementation InterpreterViewNetwork

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textView];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin =  10.0;
    CGFloat textViewX = margin;
    CGFloat textViewY = 0.0;
    CGFloat textViewW = CGRectGetWidth(self.frame) - margin*2;
    CGFloat textViewH = CGRectGetHeight(self.frame);
    self.textView.frame = CGRectMake(textViewX, textViewY, textViewW, textViewH);
}

- (void)interpretWithText:(NSString *)text {
    [self.apiManager getInterpretFromBaiduServerWithText:text];
}

#pragma mark --- APIManagerProtocol
- (void)getInterpretFromBaiduServerSuccessed:(BOOL)successed withResponse:(id)responseObject {
    if (!successed) {
        return;
    }
    NSDictionary *responseDict = (NSDictionary *)responseObject;
    NSArray *trans_result = [responseDict getArrayForKey:@"trans_result"];
    NSDictionary *resultDict = [trans_result firstObject];
    NSString *src = [resultDict getStringForKey:@"src"];
    NSString *dst = [resultDict getStringForKey:@"dst"];
    
    NSString *result = [NSString stringWithFormat:@"%@:\n   %@", src, dst];
    
    self.textView.text = result;
}

#pragma mark --- getter

- (APIManager *)apiManager {
    if (!_apiManager) {
        _apiManager = [[APIManager alloc] init];
        _apiManager.delegate = self;
    }
    
    return _apiManager;
}

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc] init];
        _textView.editable = NO;
        _textView.font = [UIFont systemFontOfSize:14.0];
    }
    
    return _textView;
}

@end
