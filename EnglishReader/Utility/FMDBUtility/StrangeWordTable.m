//
//  StrangeWordTable.m
//  EnglishReader
//
//  Created by QMTV on 17/1/10.
//  Copyright © 2017年 LFC. All rights reserved.
//

#define kStrangeWordTable @"StrangeWordTable"

#import "StrangeWordTable.h"
#import "FMDBManager.h"

@implementation StrangeWordTable

-(instancetype)init{
    self = [super init];
    if (self) {
        [[FMDBManager shareManager] creatTableWithName:kStrangeWordTable withAttributeDictionary:@{
                                                                                               @"key" : @"nvarchar",
                                                                                               @"value": @"nvarchar"
                                                                                               }];
    }
    return self;
}

/**
 *  单例对象,你总是应该通过单例使用这个类
 *
 *  @return 单例
 */
+(instancetype)shareTable{
    static StrangeWordTable *_shareTable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == _shareTable) {
            _shareTable = [[StrangeWordTable alloc] init];
        }
    });
    
    return _shareTable;
}

@end
