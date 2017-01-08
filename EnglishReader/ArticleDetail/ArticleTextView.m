//
//  ArticleTextView.m
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "ArticleTextView.h"
#import "YYKit.h"
@interface ArticleTextView ()

@property (nonatomic, strong) YYLabel *textLabel;

@end

@implementation ArticleTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.textLabel];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    
    CGFloat margin = 10.0;
    CGSize textSize = [attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - margin*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.textLabel.frame = CGRectMake(margin, 0.0, textSize.width, textSize.height);
    self.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), textSize.height);
    
    self.textLabel.attributedText = attributedText;
}

#pragma mark ----- getter

- (YYLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[YYLabel alloc] init];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.numberOfLines = 0;
    }
    
    return _textLabel;
}

@end
