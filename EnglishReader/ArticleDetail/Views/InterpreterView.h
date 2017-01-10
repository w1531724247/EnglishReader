//
//  InterpreterView.h
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterpreterViewDelegate;
@interface InterpreterView : UIView

- (void)interpretWithText:(NSString *)text;
- (void)startLoadingAnimation;

@property (nonatomic, weak) id<InterpreterViewDelegate> delegate;

@end

@protocol InterpreterViewDelegate <NSObject>

@optional
- (void)interpreterView:(InterpreterView *)interpreterView closeButtonDidTouch:(id)sender;

@end
