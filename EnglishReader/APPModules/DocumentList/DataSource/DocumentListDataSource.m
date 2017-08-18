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
#import "RootNavigationController.h"
#import "YYKit.h"
#import "DocumentDetailViewController.h"
#import "TextViewDetailController.h"
#import "WebViewDetailController.h"
#import "DocsetDetailListViewController.h"

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
            NSString *ext = [filePath pathExtension];
            if (ext.length > 1) {//只显示文件不显示文件夹
                [filePathArray addObject:filePath];
            }
        }
        
        _filePathArray = [NSArray arrayWithArray:filePathArray];
    }
    
    return _filePathArray;
}

#pragma mark ---- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *filePath = [self.filePathArray objectAtIndex:indexPath.row];
    NSString *extension = [filePath pathExtension];
    extension = [extension lowercaseString];
    
    if ([extension isEqualToString:@"docset"]) {
        DocsetDetailListViewController *detailListVC = [[DocsetDetailListViewController alloc] initWithType:DocsetDetailListTypes];
        detailListVC.filePath = filePath;
        detailListVC.hidesBottomBarWhenPushed = YES;
        if (detailListVC) {
            [tableView.viewController.navigationController pushViewController:detailListVC animated:YES];
        }
        return;
    }
    
    DocumentDetailViewController *detailVC;
    if ([extension isEqualToString:@"rtf"] || [extension isEqualToString:@"html"]) {
        detailVC = [[WebViewDetailController alloc] init];
    }
    
    if ([extension isEqualToString:@"txt"] || [extension isEqualToString:@"pdf"]) {
        detailVC = [[TextViewDetailController alloc] init];
    }
    
    if ([extension isEqualToString:@"doc"] || [extension isEqualToString:@"docx"]) {
        detailVC = [[TextViewDetailController alloc] init];
    }
    
    detailVC.filePath = filePath;
    detailVC.hidesBottomBarWhenPushed = YES;
    if (detailVC) {
        [tableView.viewController.navigationController pushViewController:detailVC animated:YES];
    }
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
