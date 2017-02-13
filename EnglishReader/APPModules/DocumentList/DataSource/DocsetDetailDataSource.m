//
//  DocsetDetailDataSource.m
//  EnglishReader
//
//  Created by QMTV on 17/2/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "DocsetDetailDataSource.h"
#import "DocumentListCell.h"
#import "DocsetHelper.h"
#import "YYKit.h"
#import "DSEntry.h"
#import "DocsetDetailListViewController.h"
#import "WebViewDetailController.h"

@interface DocsetDetailDataSource ()




@end

@implementation DocsetDetailDataSource

- (instancetype)initWithType:(DocsetDetailDataSourceType)type filtPath:(NSString *)filePath{
    self = [super init];
    if (self) {
        self.type = type;
        self.filePath = filePath;
    }
    
    return self;
}

#pragma mark ----- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.modelArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentListCell *cell = [DocumentListCell cellWithTableView:tableView];
    switch (self.type) {
        case DocsetDetailDataSourceEntries: {
            DSEntry *entry = [self.modelArray objectAtIndex:indexPath.row];
            cell.textLabel.text = entry.name;
        }
        break;
        default: {
            DSType *type = [self.modelArray objectAtIndex:indexPath.row];
            cell.textLabel.text = type.type;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", type.count];
        }
        break;
    }
    
    return cell;
}

#pragma mark ---- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.type) {
        case DocsetDetailDataSourceEntries: {
            WebViewDetailController *detailVC = [[WebViewDetailController alloc] init];
            DSEntry *entry = [self.modelArray objectAtIndex:indexPath.row];
            NSString *webUrlString = [NSString string];
            
            NSRange schemaRange = [entry.path rangeOfString:@"://"];
            if (schemaRange.location != NSNotFound) {//Xcode文档的处理方法不同
                entry.path = [entry.path substringFromIndex:schemaRange.location+schemaRange.length];
            }
            
            webUrlString = [NSString stringWithFormat:@"dash-tarix://%@/Contents/Resources/Documents/%@", self.filePath, entry.path];
            
            detailVC.filePath = webUrlString;
            detailVC.hidesBottomBarWhenPushed = YES;
            if (detailVC) {
                [tableView.viewController.navigationController pushViewController:detailVC animated:YES];
            }
        }
        break;
        default: {
            DocsetDetailListViewController *detailListVC = [[DocsetDetailListViewController alloc] initWithType:DocsetDetailListEntries];
            DSType *typeModel = [self.modelArray objectAtIndex:indexPath.row];
            detailListVC.typeModel = typeModel;
            detailListVC.filePath = self.filePath;
            detailListVC.hidesBottomBarWhenPushed = YES;
            if (detailListVC) {
                [tableView.viewController.navigationController pushViewController:detailListVC animated:YES];
            }
        }
        break;
    }
}


@end
