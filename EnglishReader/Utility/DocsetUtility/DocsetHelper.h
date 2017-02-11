//
//  DocsetHelper.h
//  EnglishReader
//
//  Created by QMTV on 17/2/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocsetHelper : NSObject

- (NSArray *)typeListWithDocsetPath:(NSString *)docsetPath;
- (NSArray *)entryListWithDocsetPath:(NSString *)docsetPath andType:(NSString *)type;

@end
