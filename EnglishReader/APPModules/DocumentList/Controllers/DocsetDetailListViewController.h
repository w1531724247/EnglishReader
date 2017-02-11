//
//  DocsetDetailListViewController.h
//  EnglishReader
//
//  Created by QMTV on 17/2/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "DocumentListViewController.h"
#import "DSType.h"

typedef NS_ENUM(NSInteger, DocsetDetailListType) {
    DocsetDetailListTypes = 0,
    DocsetDetailListEntries
};

@interface DocsetDetailListViewController : DocumentListViewController

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) DocsetDetailListType type;
@property (nonatomic, strong) DSType *typeModel;

- (instancetype)initWithType:(DocsetDetailListType)type;

@end
