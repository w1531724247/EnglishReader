//
//  StrangeWordTable.h
//  EnglishReader
//
//  Created by QMTV on 17/1/10.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StrangeWordTable : NSObject
/**
 *  单例对象,你总是应该通过单例使用这个类
 *
 *  @return 单例
 */
+(instancetype)shareTable;

@end
