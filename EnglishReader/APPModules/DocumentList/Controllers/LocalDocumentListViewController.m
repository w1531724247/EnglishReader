//
//  LocalDocumentListViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/2/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "LocalDocumentListViewController.h"
#import "DocumentListDataSource.h"

@interface LocalDocumentListViewController ()

@property (nonatomic, strong) DocumentListDataSource *dataSource;

@end

@implementation LocalDocumentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    self.title = @"文档列表";
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


@end
