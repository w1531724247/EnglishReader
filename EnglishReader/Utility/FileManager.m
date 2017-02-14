//
//  FileManager.m
//  EnglishReader
//
//  Created by QMTV on 17/1/9.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (NSString *)dataInfoDirectory{
    NSString *dataInfoDirectory = [NSString string];
    
    BOOL successed = [FileManager creatDocumentSubDirectoryWithString:@"DataInfo"];
    if (successed) {
        dataInfoDirectory = [NSString stringWithFormat:@"%@/DataInfo", [FileManager documentDirectory]];
        return dataInfoDirectory;
    }
    return nil;
}
+ (NSString *)interfaceInfoDirectory{
    NSString *dataInfoDirectory = [NSString string];
    
    BOOL successed = [FileManager creatDocumentSubDirectoryWithString:@"interfaceInfo"];
    if (successed) {
        dataInfoDirectory = [NSString stringWithFormat:@"%@/interfaceInfo", [FileManager documentDirectory]];
        return dataInfoDirectory;
    }
    
    return nil;
}

+ (NSString *)dataInfoDirectoryWithFileName:(NSString *)fielName{
    
    return [NSString stringWithFormat:@"%@/%@", [FileManager dataInfoDirectory], fielName];
}

+ (NSString *)interfaceInfoDirectoryWithFileName:(NSString *)fielName{
    
    return [NSString stringWithFormat:@"%@/%@", [FileManager interfaceInfoDirectory], fielName];
}

+ (NSString *)documentDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

+ (NSString *)cachesDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

+ (NSString *)tempDirectory
{
    return NSTemporaryDirectory();
}

+ (BOOL)creatDocumentSubDirectoryWithString:(NSString *)directory{
    BOOL successed = NO;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [FileManager documentDirectory];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@", pathDocuments, directory];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        [FileManager setNotBackUpiCloudWithDirectory:createPath];
        successed = YES;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        successed = YES;
    }
    
    return successed;
}

+ (NSString *)getDocumentSubDirectoryWithString:(NSString *)directory{
    NSString *pathDocuments = [FileManager documentDirectory];
    NSString *path = [NSString stringWithFormat:@"%@/%@", pathDocuments, directory];
    return path;
}

+ (NSArray *)getDocumentSubDirectory {
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *pathDocuments = [FileManager documentDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:pathDocuments error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [array addObject:filename];
    }
    
    return [NSArray arrayWithArray:array];
}

+ (NSArray *)getSubDirectoryWithDirectory:(NSString *)directory {
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *pathDocuments = directory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:pathDocuments error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [array addObject:filename];
    }
    
    return [NSArray arrayWithArray:array];
}


//设置禁止云同步
+ (BOOL)setNotBackUpiCloudWithDirectory:(NSString *)directory{
    NSURL *url = [NSURL URLWithString:directory];
    
    NSError *error = nil;
    
    BOOL success = [url setResourceValue:[NSNumber numberWithBool:YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
    }
    
    return success;
}

+ (BOOL)removeFileWithPath:(NSString *)filePath{
    BOOL successed = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        successed = [fileManager removeItemAtPath:filePath error:&error];
        NSLog(@"removeFileWithPath-->error: %@", error);
    }
    
    return successed;
}


+ (BOOL)removeAllFileWithDirectory:(NSString *)directory{
    BOOL successed = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:directory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        successed = [fileManager removeItemAtPath:[directory stringByAppendingPathComponent:filename] error:NULL];
    }
    
    return successed;
}

+ (NSData *)getLocalNetworkingDataWithFileName:(NSString *)fileName{
    // 1.将网址初始化成一个OC字符串对象
    NSString *urlStr = [NSString stringWithFormat:@"http://localhost/QMTV/%@", fileName];
    // 如果网址中存在中文,进行URLEncode
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 2.构建网络URL对象, NSURL
    NSURL *url = [NSURL URLWithString:newUrlStr];
    // 3.创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    // 创建同步链接
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return data;
}

@end
