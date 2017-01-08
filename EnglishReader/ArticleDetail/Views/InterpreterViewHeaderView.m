//
//  InterpreterViewHeaderView.m
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "InterpreterViewHeaderView.h"
#import "Masonry.h"

@interface InterpreterViewHeaderView ()

@property (nonatomic, strong) UIImageView *dragImageView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation InterpreterViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.dragImageView];
        [self addSubview:self.closeButton];
        [self addConstraintsToSubviews];
    }
    
    return self;
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
        make.width.height.equalTo(@(44));
    }];
    
    [self.closeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(44));
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

#pragma mark --- getter

- (UIImageView *)dragImageView {
    if (!_dragImageView) {
        _dragImageView = [[UIImageView alloc] init];
        _dragImageView.backgroundColor = [UIColor redColor];
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

@end
