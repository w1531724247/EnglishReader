//
//  MainViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/7.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "MainViewController.h"
#import "YYKit.h"
#import "DocumentListViewController.h"
#import "UIColor+Extention.h"

@interface MainViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSliderContainer];
    
    [self.magicView reloadData];
}

#pragma mark ----- private
- (void)configSliderContainer{
    self.magicView.navigationHeight = 44;
    self.magicView.againstStatusBar = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.magicView.headerView.backgroundColor = [UIColor whiteColor];
    
    self.magicView.layoutStyle = VTLayoutStyleDefault;
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = [UIColor colorWithRGB:0xff5a52];
    self.magicView.itemSpacing = 40.f;
    
    self.magicView.separatorColor = [UIColor colorWithRGB:0xe6edf0];
    [self.magicView setHeaderHidden:NO];
}


#pragma mark ----- VTMagicViewDataSource
/**
 *  获取所有菜单名，数组中存放字符串类型对象
 *
 *  @param magicView self
 *
 *  @return header数组
 */
- (NSArray<__kindof NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSArray *titles = [NSArray arrayWithObjects:@"文档列表", nil];//, @"单词本", @"设置", @"我"
    
    return titles;
}

/**
 *  根据itemIndex加载对应的menuItem
 *
 *  @param magicView self
 *  @param itemIndex 需要加载的菜单索引
 *
 *  @return 当前索引对应的菜单按钮
 */
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [button setTitleColor:[UIColor colorWithRGB:0x333333] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRGB:0xff5a52] forState:UIControlStateSelected];
    
    return button;
}

/**
 *  根据pageIndex加载对应的页面控制器
 *
 *  @param magicView self
 *  @param pageIndex 需要加载的页面索引
 *
 *  @return 页面控制器
 */
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    if (pageIndex == 0) {
        DocumentListViewController *documentListVC = [[DocumentListViewController alloc] init];
        
        return documentListVC;
    } else {
        UIViewController *VC = [[UIViewController alloc] init];
        VC.view.backgroundColor = [UIColor randomColor];
        
        return VC;
    }
}

#pragma mark ----- VTMagicViewDelegate
/**
 *  视图控制器显示到当前屏幕上时触发
 *
 *  @param magicView      self
 *  @param viewController 当前页面展示的控制器
 *  @param pageIndex      当前控控制器对应的索引
 */
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    
}

/**
 *  视图控制器从屏幕上消失时触发
 *
 *  @param magicView      self
 *  @param viewController 消失的视图控制器
 *  @param pageIndex      消失的控制器对应的索引
 */
- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {

}

/**
 *  选中导航菜单item时触发
 *
 *  @param magicView self
 *  @param itemIndex menuItem对应的索引
 */
- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {

}

/**
 *  根据itemIndex获取对应menuItem的宽度，若返回结果为0，内部将自动计算其宽度
 *
 *  @param magicView self
 *  @param itemIndex menuItem对应的索引
 *
 *  @return menuItem的宽度
 */
- (CGFloat)magicView:(VTMagicView *)magicView itemWidthAtIndex:(NSUInteger)itemIndex {
    return CGRectGetWidth([UIScreen mainScreen].bounds)/4.0;
}

/**
 *  根据itemIndex获取对应slider的宽度，若返回结果为0，内部将自动计算其宽度
 *
 *  @param magicView self
 *  @param itemIndex slider对应的索引
 *
 *  @return slider的宽度
 */
- (CGFloat)magicView:(VTMagicView *)magicView sliderWidthAtIndex:(NSUInteger)itemIndex {
    return CGRectGetWidth([UIScreen mainScreen].bounds)/4.0;
}


@end
