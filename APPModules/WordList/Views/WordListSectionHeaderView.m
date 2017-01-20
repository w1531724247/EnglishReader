//
//  WOrdListSectionHeaderView.m
//  EnglishReader
//
//  Created by LFC on 17/1/20.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "WordListSectionHeaderView.h"
#import "Masonry.h"
#import "UIManager.h"

@interface WordListSectionHeaderView ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation WordListSectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addConstraintsToSubviews];
    }
    
    return self;
}

- (void)addConstraintsToSubviews {
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
}

- (void)setSectionTitle:(NSString *)sectionTitle {
    _sectionTitle = sectionTitle;
    
    self.titleLabel.text = [NSString stringWithFormat:@"   %@", sectionTitle];
}

#pragma mark -----  getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = [UIManager textColor];
    }
    
    return _titleLabel;
}

@end
