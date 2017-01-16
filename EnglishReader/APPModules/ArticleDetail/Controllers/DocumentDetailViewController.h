//
//  DocumentDetailViewController.h
//  EnglishReader
//
//  Created by QMTV on 17/1/16.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterpreterView.h"

@interface DocumentDetailViewController : UIViewController<InterpreterViewDelegate>

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) InterpreterView *interpreterView;

-  (void)showInterpreterViewWithText:(NSString *)text;
- (void)hiddenInterpreterView;

@end
