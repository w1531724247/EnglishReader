//
//  InterpreterViewHeaderView.m
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "InterpreterViewHeaderView.h"
#import "Masonry.h"
#import "YYKit.h"

@interface InterpreterViewHeaderView ()

@property (nonatomic, strong) UIImageView *dragImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIActivityIndicatorView *indicationView;
@end

@implementation InterpreterViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.dragImageView];
        [self addSubview:self.closeButton];
        [self addSubview:self.indicationView];
        [self addConstraintsToSubviews];
    }
    
    return self;
}

#pragma mark --- public

- (void)startLoadingAnimation {
    self.closeButton.hidden = YES;
    [self.indicationView startAnimating];
}

- (void)stopLoadingAnimation {
    self.closeButton.hidden = NO;
    [self.indicationView stopAnimating];
}

- (void)dragImageUpDown:(BOOL)upDown {
    if (upDown) {
        [self.dragImageView setImage:[UIImage imageNamed:@"drag_up_down_indicatorImage"]];
    } else {
        [self.dragImageView setImage:[UIImage imageNamed:@"drag_down_indicatorImage"]];
    }
}

#pragma mark --- action
- (void)addCloseButtonEventToTarget:(nullable id)target action:(nonnull SEL)selector forControlEvents:(UIControlEvents)controlEvents {
    [self.closeButton addTarget:target action:selector forControlEvents:controlEvents];
}

#pragma amrk --- private

- (void)addConstraintsToSubviews {
    [self.dragImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@(22));
    }];
    
    [self.closeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(44));
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.indicationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.closeButton.mas_centerX);
        make.centerY.equalTo(self.closeButton.mas_centerY);
    }];
}

#pragma mark --- getter

- (UIImageView *)dragImageView {
    if (!_dragImageView) {
        _dragImageView = [[UIImageView alloc] init];
        _dragImageView.image = [UIImage imageNamed:@"drag_up_down_indicatorImage"];
    }
    
    return _dragImageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"btn_fenlei_close"] forState:UIControlStateNormal];
    }
    
    return _closeButton;
}

- (UIActivityIndicatorView *)indicationView {
    if (!_indicationView) {
        _indicationView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _indicationView;
}


@end
