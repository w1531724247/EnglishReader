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
#import "ArticleDetailViewController.h"
#import "RootNavigationController.h"
#import "YYKit.h"
#import "WebDetailViewController.h"

@interface DocumentListDataSource () 

//文件数组
@property (nonatomic, strong, readwrite) NSArray *filePathArray;

@end

@implementation DocumentListDataSource

#pragma mark ----- public

- (void)removeFileAtIndex:(NSInteger)index {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.filePathArray];
    NSString *filePath = [self.filePathArray objectAtIndex:index];
    [tempArray removeObject:filePath];
    self.filePathArray = [NSArray arrayWithArray:tempArray];
    [FileManager removeFileWithPath:filePath];
}

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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark --- getter

- (NSArray *)filePathArray {
    if (!_filePathArray) {
        NSString *resourcePath = [FileManager documentDirectory];
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

#pragma mark ---- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebDetailViewController *detailVC = [[WebDetailViewController alloc] init];
    detailVC.urlString = [self.filePathArray objectAtIndex:indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [tableView.viewController.navigationController pushViewController:detailVC animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 判断点击按钮的样式 来去做添加 或删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeFileAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
