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
#import "YYKit.h"

@interface InterpreterView ()<InterpreterContentViewProtocol>

@property (nonatomic, strong) InterpreterViewHeaderView *headerView;
@property (nonatomic, strong) InterpreterViewNetwork *interpreterViewNet;
@property (nonatomic, strong) InterpreterViewLocal *interpreterViewLocal;
@property (nonatomic, assign) CGRect startDragFrame;

@end

@implementation InterpreterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headerView];
        [self addSubview:self.interpreterViewLocal];
        [self addSubview:self.interpreterViewNet];
        
        [self addConstraintsToSubviews];
        [self addGestureRecognizerToHeaderView];
    }
    
    return self;
}

#pragma mark ---- public

- (void)interpretWithText:(NSString *)text {
    if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:text]) {
        self.interpreterViewLocal.hidden = NO;
        self.interpreterViewNet.hidden = YES;
        [self.interpreterViewLocal interpretWithText:text];
    } else {
        self.interpreterViewLocal.hidden = YES;
        self.interpreterViewNet.hidden = NO;
        [self.interpreterViewNet interpretWithText:text];
    }
}

- (void)startLoadingAnimation {
    [self.headerView startLoadingAnimation];
}

#pragma mark ---- InterpreterContentViewProtocol

- (void)interpreterSuccessed {
    [self.headerView stopLoadingAnimation];
}

- (void)interpreterFailure {
    [self.headerView stopLoadingAnimation];
}

#pragma mark ---- private

- (void)addConstraintsToSubviews {
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(44));
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

- (void)addGestureRecognizerToHeaderView {
    UIPanGestureRecognizer *panGSRG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewDidDrag:)];
    [self.headerView addGestureRecognizer:panGSRG];
}

- (void)headerViewDidDrag:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.startDragFrame = self.frame;
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self autoFrameWithAnimation];
        return;
    }
    
    if (translation.y < 0) {//向上
        
    } else if (translation.y > 0) {//向下
        
    }
    
    CGRect frame = self.startDragFrame;
    frame.origin.y += translation.y;
    frame.size.height -= translation.y;
    if (frame.origin.y <= 64.0) {
        frame.origin.y = 64.0;
    }
    self.frame = frame;
}

- (void)autoFrameWithAnimation {
    CGFloat originY = self.frame.origin.y;
    CGFloat selfX = 0.0;
    CGFloat selfY;
    CGFloat selfW = CGRectGetWidth(self.superview.frame);
    CGFloat selfH;
    [self.headerView dragImageUpDown:YES];
    if (originY < [UIScreen mainScreen].bounds.size.height - 350.0) {
        selfY = 64.0;
        selfH = CGRectGetHeight(self.superview.frame) - selfY;
        [self.headerView dragImageUpDown:NO];
    } else if (originY > [UIScreen mainScreen].bounds.size.height - 350.0 && originY < [UIScreen mainScreen].bounds.size.height - 200.0) {
        selfH = 250.0;
        selfY = CGRectGetHeight(self.superview.frame) - selfH;
    } else if (originY > [UIScreen mainScreen].bounds.size.height - 200.0) {
        selfH = 250.0;
        selfY = CGRectGetHeight(self.superview.frame);
    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(selfX, selfY, selfW, selfH);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark ---- action
- (void)closeButtonDidTouch:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(interpreterView:closeButtonDidTouch:)]) {
        [self.headerView dragImageUpDown:YES];
        [self.delegate interpreterView:self closeButtonDidTouch:nil];
    }
}

#pragma mark ---- getter

- (InterpreterViewHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[InterpreterViewHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor colorWithRGB:0x888888];
        [_headerView addCloseButtonEventToTarget:self action:@selector(closeButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _headerView;
}

- (InterpreterViewNetwork *)interpreterViewNet {
    if (!_interpreterViewNet) {
        _interpreterViewNet = [[InterpreterViewNetwork alloc] init];
        _interpreterViewNet.delegate = self;
    }
    
    return _interpreterViewNet;
}

- (InterpreterViewLocal *)interpreterViewLocal {
    if (!_interpreterViewLocal) {
        _interpreterViewLocal = [[InterpreterViewLocal alloc] init];
        _interpreterViewLocal.delegate = self;
    }
    
    return _interpreterViewLocal;
}

@end
