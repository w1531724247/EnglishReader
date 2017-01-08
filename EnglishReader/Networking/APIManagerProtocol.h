//
//  APIManagerProtocol.h
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIManagerProtocol <NSObject>

//从百度翻译API查询结果
- (void)getInterpretFromBaiduServerSuccessed:(BOOL)successed withResponse:(id)responseObject;

@end
