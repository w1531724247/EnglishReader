//
//  InterpreterView.m
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//


#import "InterpreterView.h"
#import "InterpreterViewHeaderView.h"
#import "InterpreterViewLocal.h"
#import "InterpreterViewNetwork.h"
#import <UIKit/UIReferenceLibraryViewController.h>
#import "Masonry.h"

@interface InterpreterView ()

@property (nonatomic, strong) InterpreterViewHeaderView *headerView;
@property (nonatomic, strong) InterpreterViewNetwork *interpreterViewNet;
@property (nonatomic, strong) InterpreterViewLocal *interpreterViewLocal;
@property (nonatomic, strong) UIView *interpreterView;

@end

@implementation InterpreterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headerView];
        [self addSubview:self.interpreterViewLocal];
        [self addSubview:self.interpreterViewNet];
        
        [self addConstraintsToSubviews];
    }
    
    return self;
}

#pragma mark ---- public

- (void)interpretWithText:(NSString *)text {
    if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:text]) {
        [self bringSubviewToFront:self.interpreterViewLocal];
        [self.interpreterViewLocal interpretWithText:text];
        self.interpreterView = self.interpreterViewLocal;
    } else {
        [self bringSubviewToFront:self.interpreterViewNet];
        [self.interpreterViewNet interpretWithText:text];
        self.interpreterView = self.interpreterViewNet;
    }
}

#pragma mark ---- private

- (void)addConstraintsToSubviews {
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(50));
        make.top.equalTo(self.mas_top);
    }];
    
    [self.interpreterViewLocal mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.interpreterViewNet mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

#pragma mark ---- action

- (void)closeButtonDidTouch:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(interpreterView:closeButtonDidTouch:)]) {
        [self.delegate interpreterView:self closeButtonDidTouch:nil];
    }
}

#pragma mark ---- getter

- (InterpreterViewHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[InterpreterViewHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor grayColor];
        [_headerView addCloseButtonEventToTarget:self action:@selector(closeButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _headerView;
}

- (InterpreterViewNetwork *)interpreterViewNet {
    if (!_interpreterViewNet) {
        _interpreterViewNet = [[InterpreterViewNetwork alloc] init];
    }
    
    return _interpreterViewNet;
}

- (InterpreterViewLocal *)interpreterViewLocal {
    if (!_interpreterViewLocal) {
        _interpreterViewLocal = [[InterpreterViewLocal alloc] init];
    }
    
    return _interpreterViewLocal;
}

@end
