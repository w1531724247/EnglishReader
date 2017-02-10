//
//  WordDetailViewController.h
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordDetailViewController : UIViewController

@property (nonatomic, copy) NSString *word;
- (instancetype)initWithWord:(NSString *)word;

@end
