//
//  ArticleTextView.m
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "ArticleTextView.h"
#import "Masonry.h"

@interface ArticleTextView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ArticleTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self insertSubview:self.backgroundImageView atIndex:0];
        self.selectable = NO;
        self.editable = NO;
    }
    
    return self;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
//    CGFloat backgroundImageViewX = 0.0;
//    CGFloat backgroundImageViewY = -CGRectGetHeight(self.frame);
//    CGFloat backgroundImageViewW = CGRectGetWidth(self.frame);
//    CGFloat backgroundImageViewH = self.contentSize.height + CGRectGetHeight(self.frame)*2;
//    self.backgroundImageView.frame = CGRectMake(backgroundImageViewX, backgroundImageViewY, backgroundImageViewW, backgroundImageViewH);
}

#pragma mark ----- getter


- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_3.jpg"]];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    return _backgroundImageView;
}

@end
