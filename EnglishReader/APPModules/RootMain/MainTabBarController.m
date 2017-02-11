//
//  MainTabBarController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/10.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "MainTabBarController.h"
#import "LocalDocumentListViewController.h"
#import "UIManager.h"
#import "SettingViewController.h"
#import "WordListViewController.h"
#import "MineViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupChildViewController];
}

-(void)setupChildViewController {
    LocalDocumentListViewController *documentListVC = [[LocalDocumentListViewController alloc] init];
    UINavigationController *documentListNav = [[UINavigationController alloc] initWithRootViewController:documentListVC];
    
    WordListViewController *wordListVC = [[WordListViewController alloc] init];
    UINavigationController *wordListNav = [[UINavigationController alloc] initWithRootViewController:wordListVC];
    
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingVC];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIManager textColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIManager textSelectedColor]} forState:UIControlStateSelected];
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    self.viewControllers = [NSArray arrayWithObjects:documentListNav, wordListNav, settingNav, mineNav, nil];
}

@end
