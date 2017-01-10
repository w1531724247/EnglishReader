//
//  InterpreterView.h
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterpreterContentViewProtocol.h"

@interface InterpreterViewLocal : UIView

@property (nonatomic, weak) id<InterpreterContentViewProtocol> delegate;
- (void)interpretWithText:(NSString *)text;

@end
