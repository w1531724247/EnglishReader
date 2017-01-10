//
//  DocumentListDataSource.h
//  EnglishReader
//
//  Created by QMTV on 17/1/9.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DocumentListDataSource : NSObject <UITableViewDataSource>

//文件数组
@property (nonatomic, strong, readonly) NSArray *filePathArray;

@end
