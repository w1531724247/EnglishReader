//
//  DocsetDetailListViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/2/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "DocsetDetailListViewController.h"
#import "DocsetDetailDataSource.h"
#import "DocsetHelper.h"

@interface DocsetDetailListViewController ()

@property (nonatomic, strong) DocsetDetailDataSource *dataSource;
@property (nonatomic, strong) DocsetHelper *docHelper;

@end

@implementation DocsetDetailListViewController

- (instancetype)initWithType:(DocsetDetailListType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    
    self.title = [[self.filePath stringByDeletingPathExtension] lastPathComponent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----  getter

- (DocsetDetailDataSource *)dataSource {
    if (!_dataSource) {
        switch (self.type) {
            case DocsetDetailListEntries: {
                _dataSource = [[DocsetDetailDataSource alloc] initWithType:DocsetDetailDataSourceEntries filtPath:self.filePath];
                _dataSource.modelArray = [self.docHelper entryListWithDocsetPath:self.filePath andType:self.typeModel.type];
            }
            break;
            default: {
                _dataSource = [[DocsetDetailDataSource alloc] initWithType:DocsetDetailDataSourceTypes filtPath:self.filePath];
                _dataSource.modelArray = [self.docHelper typeListWithDocsetPath:self.filePath];
            }
            break;
        }
    }
    
    return _dataSource;
}

- (DocsetHelper *)docHelper {
    if (!_docHelper) {
        _docHelper = [[DocsetHelper alloc] init];
    }
    
    return _docHelper;
}

@end
