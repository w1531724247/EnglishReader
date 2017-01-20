//
//  WordListDataSource.m
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "WordListDataSource.h"
#import "WordListCell.h"
#import "FileManager.h"
#import "WordDetailViewController.h"
#import "YYKit.h"
#import "StrangeWordTable.h"
#import "NSDictionary+JSONHelper.h"
#import "WordRecordModel.h"
#import "WordListSectionHeaderView.h"

@interface WordListDataSource ()

@property (nonatomic, strong) NSArray *documentArray;//文档列表
@property (nonatomic, strong) NSArray *sectionTitleArray;//分段标题列表
@property (nonatomic, strong) NSArray *wordListArray;//单词数组列表

@end

@implementation WordListDataSource
//根据文章名字排序
- (void)wordListOrderByArticleNameWithTableView:(UITableView *)tableView {
    [self getWordListByArticleName];
    [tableView reloadData];
}

//根据首字母排序
- (void)wordListOrderByFirstUpperLetterWithTableView:(UITableView *)tableView {
    [self getWordListByFirstUpperLetter];
    [tableView reloadData];
}

#pragma mark------ private

- (void)getWordListByArticleName {
    NSMutableArray *sectionTitleTempArray = [NSMutableArray array];
    NSMutableArray *wordListTempArray = [NSMutableArray array];
    for (NSString *articleName in self.documentArray) {
        NSArray *wordList = [[StrangeWordTable shareTable] queryStrangeWordByArticleName:articleName];
        [sectionTitleTempArray addObject:articleName];
        [wordListTempArray addObject:wordList];
    }
    
    self.sectionTitleArray = sectionTitleTempArray;
    self.wordListArray = wordListTempArray;
}

- (void)getWordListByFirstUpperLetter {
    NSArray *letterArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSMutableArray *sectionTitleTempArray = [NSMutableArray array];
    NSMutableArray *wordListTempArray = [NSMutableArray array];
    for (NSString *letter in letterArray) {
        NSArray *wordList = [[StrangeWordTable shareTable] queryStrangeWordByFirstUpperLetter:letter];
        [sectionTitleTempArray addObject:letter];
        [wordListTempArray addObject:wordList];
    }
    
    self.sectionTitleArray = sectionTitleTempArray;
    self.wordListArray = wordListTempArray;
}

#pragma mark ----- public

- (void)removeWordAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ----- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *wordList = [self.wordListArray objectAtIndex:section];
    return [wordList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WordListCell *cell = [WordListCell cellWithTableView:tableView];
    NSArray *wordList = [self.wordListArray objectAtIndex:indexPath.section];
    NSDictionary *wordRecordDict = [wordList objectAtIndex:indexPath.row];
    WordRecordModel *wordRecord = [WordRecordModel modelWithDictionary:wordRecordDict];
    cell.textLabel.text = wordRecord.word;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *identifier = @"WordListSectionHeaderView";
    WordListSectionHeaderView *sectionHeaderView = [[WordListSectionHeaderView alloc] initWithReuseIdentifier:identifier];
    NSString *sectionTitle = [self.sectionTitleArray objectAtIndex:section];
    sectionHeaderView.sectionTitle = sectionTitle;
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

#pragma mark ---- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *wordList = [self.wordListArray objectAtIndex:indexPath.section];
    NSDictionary *wordRecordDict = [wordList objectAtIndex:indexPath.row];
    WordRecordModel *wordRecord = [WordRecordModel modelWithDictionary:wordRecordDict];
    
    WordDetailViewController *detailVC = [[WordDetailViewController alloc] initWithWord:wordRecord.word];
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
        [self removeWordAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}


#pragma mark --- getter
- (NSArray *)documentArray {
    if (!_documentArray) {
        NSString *resourcePath = [FileManager documentDirectory];
        NSArray *files = [FileManager getSubDirectoryWithDirectory:resourcePath];
        
        _documentArray = files;
    }
    
    return _documentArray;
}
@end
