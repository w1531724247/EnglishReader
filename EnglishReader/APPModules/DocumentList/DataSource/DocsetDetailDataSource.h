//
//  DocsetDetailDataSource.h
//  EnglishReader
//
//  Created by QMTV on 17/2/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DSType.h"

typedef NS_ENUM(NSInteger, DocsetDetailDataSourceType) {
    DocsetDetailDataSourceTypes = 0,
    DocsetDetailDataSourceEntries
};

@interface DocsetDetailDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) DocsetDetailDataSourceType type;
- (instancetype)initWithType:(DocsetDetailDataSourceType)type filtPath:(NSString *)filePath;

@end
