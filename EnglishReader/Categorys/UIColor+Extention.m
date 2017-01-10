//
//  UIColor+Extention.m
//  EnglishReader
//
//  Created by QMTV on 17/1/9.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "UIColor+Extention.h"

@implementation UIColor (Extention)
+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
}
@end
