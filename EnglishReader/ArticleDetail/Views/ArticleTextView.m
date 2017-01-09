//
//  ArticleTextView.m
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "ArticleTextView.h"
#import "YYKit.h"
#import "Masonry.h"

@interface ArticleTextView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
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
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.textLabel];
    
    self.backgroundImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_3.jpg"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    
    CGFloat margin = 10.0;
    CGSize textSize = [attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - margin*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.textLabel.frame = CGRectMake(margin, 0.0, textSize.width, textSize.height);
    self.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), textSize.height);
    
    self.textLabel.attributedText = attributedText;
    
    CGFloat backgroundImageViewX = 0.0;
    CGFloat backgroundImageViewY = 0.0;
    CGFloat backgroundImageViewW = CGRectGetWidth(self.frame);
    CGFloat backgroundImageViewH = textSize.height;
    self.backgroundImageView.frame = CGRectMake(backgroundImageViewX, backgroundImageViewY, backgroundImageViewW, backgroundImageViewH);
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

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    
    return _backgroundImageView;
}

@end
