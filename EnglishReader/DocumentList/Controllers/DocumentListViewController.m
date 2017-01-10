//
//  DocumentListViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/9.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "DocumentListViewController.h"
#import "DocumentListDataSource.h"

@interface DocumentListViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DocumentListDataSource *dataSource;

@end

@implementation DocumentListViewController

- (void)loadView {
    [super loadView];
    
    self.view = self.tableView;
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- getter

- (DocumentListDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[DocumentListDataSource alloc] init];
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
