//
//  RootNavigationController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/7.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "RootNavigationController.h"
#import "MainViewController.h"
#import "DocumentListViewController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

+ (instancetype)shareNavigationController {
    static RootNavigationController *_shareNavigationController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareNavigationController) {
            DocumentListViewController *mainVC = [[DocumentListViewController alloc] init];
            _shareNavigationController = [[RootNavigationController alloc] initWithRootViewController:mainVC];
        }
    });
    
    return _shareNavigationController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
