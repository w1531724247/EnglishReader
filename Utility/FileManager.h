//
//  FileManager.h
//  EnglishReader
//
//  Created by QMTV on 17/1/9.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+(NSString *)dataInfoDirectory;
+(NSString *)dataInfoDirectoryWithFileName:(NSString *)fielName;
+(NSString *)documentDirectory;
+(NSString *)cachesDirectory;
+(NSString *)tempDirectory;
+(BOOL)creatDocumentSubDirectoryWithString:(NSString *)directory;
+(NSString *)getDocumentSubDirectoryWithString:(NSString *)directory;
+(NSArray *)getDocumentSubDirectory;
+(NSArray *)getSubDirectoryWithDirectory:(NSString *)directory;

+(BOOL)removeFileWithPath:(NSString *)filePath;
+(BOOL)removeAllFileWithDirectory:(NSString *)directory;

+(NSData *)getLocalNetworkingDataWithFileName:(NSString *)fileName;

+(NSString *)interfaceInfoDirectoryWithFileName:(NSString *)fielName;
+(NSString *)interfaceInfoDirectory;

@end
