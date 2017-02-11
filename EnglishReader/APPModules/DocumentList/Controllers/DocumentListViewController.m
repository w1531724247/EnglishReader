//
//  DocumentListViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/9.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "DocumentListViewController.h"


@interface DocumentListViewController ()

@property (nonatomic, strong, readwrite) UITableView *tableView;

@end

@implementation DocumentListViewController

- (void)loadView {
    [super loadView];
    
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

@end
