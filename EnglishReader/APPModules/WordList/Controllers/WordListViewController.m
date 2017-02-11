//
//  WordListViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/10.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "WordListViewController.h"
#import "WordListDataSource.h"

@interface WordListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WordListDataSource *dataSource;

@end

@implementation WordListViewController

- (void)loadView {
    [super loadView];
    
    self.view = self.tableView;
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"单词本";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.dataSource wordListOrderByFirstUpperLetterWithTableView:self.tableView];
}

#pragma mark ---- getter

- (WordListDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[WordListDataSource alloc] init];
    }
    
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}


@end
