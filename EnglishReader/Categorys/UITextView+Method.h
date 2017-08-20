//
//  UITextView+Method.h
//  Dash iOS
//
//  Created by QMTV on 2017/8/19.
//  Copyright © 2017年 Kapeli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Method)

- (void)hookSetText;

- (void)restoreSetText;

- (void)hookSetAttributeText;

- (void)restoreSetAttributeText;

@end
