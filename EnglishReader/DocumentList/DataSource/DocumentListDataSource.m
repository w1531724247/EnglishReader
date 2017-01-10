//
//  DocumentListDataSource.m
//  EnglishReader
//
//  Created by QMTV on 17/1/9.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "DocumentListDataSource.h"
#import "FileManager.h"
#import "DocumentListCell.h"

@interface DocumentListDataSource () 

//文件数组
@property (nonatomic, strong, readwrite) NSArray *filePathArray;

@end

@implementation DocumentListDataSource

#pragma mark ----- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filePathArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentListCell *cell = [DocumentListCell cellWithTableView:tableView];
    cell.textLabel.text = [[self.filePathArray objectAtIndex:indexPath.row] lastPathComponent];
    
    return cell;
}

#pragma mark --- getter

- (NSArray *)filePathArray {
    if (!_filePathArray) {
        NSString *resourcePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Resource"];
        NSArray *files = [FileManager getSubDirectoryWithDirectory:resourcePath];
        
        NSMutableArray *filePathArray = [NSMutableArray array];
        for (NSString *file in files) {
            NSString *filePath = [resourcePath stringByAppendingPathComponent:file];
            [filePathArray addObject:filePath];
        }
        
        _filePathArray = [NSArray arrayWithArray:filePathArray];
    }
    
    return _filePathArray;
}

@end
