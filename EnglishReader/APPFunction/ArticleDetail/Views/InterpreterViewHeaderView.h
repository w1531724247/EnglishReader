//
//  InterpreterViewHeaderView.h
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterpreterViewHeaderView : UIView

- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;
- (void)dragImageUpDown:(BOOL)upDown;
- (void)addCloseButtonEventToTarget:(nullable id)target action:(nonnull SEL)selector forControlEvents:(UIControlEvents)controlEvents;

@end
