//
//  WordListDataSource.h
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WordListDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

//根据文章名字排序
- (void)wordListOrderByArticleNameWithTableView:(UITableView *)tableView;

//根据首字母排序
- (void)wordListOrderByFirstUpperLetterWithTableView:(UITableView *)tableView;
@end
