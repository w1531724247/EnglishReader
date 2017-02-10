//
//  APIManager.h
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIManagerProtocol.h"

@interface APIManager : NSObject

@property (nonatomic, weak) id<APIManagerProtocol> delegate;

//从百度翻译API查询结果
- (void)getInterpretFromBaiduServerWithText:(NSString *)text;

@end
