//
//  DocumentDetailViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/16.
//  Copyright © 2017年 LFC. All rights reserved.
//
#define kWebViewHeight 250.0

#import "DocumentDetailViewController.h"

@interface DocumentDetailViewController ()

@end

@implementation DocumentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [[self.filePath stringByDeletingPathExtension] lastPathComponent];
    [self hiddenInterpreterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- InterpreterViewDelegate
- (void)interpreterView:(InterpreterView *)interpreterView closeButtonDidTouch:(id)sender {
    [self hiddenInterpreterView];
}

#pragma mark ----- private
-  (void)showInterpreterViewWithText:(NSString *)text {
    [self.interpreterView startLoadingAnimation];
    
    CGFloat interpreterViewX = 0.0;
    CGFloat interpreterViewY = CGRectGetHeight(self.view.frame) - kWebViewHeight;
    CGFloat interpreterViewW = CGRectGetWidth(self.view.frame);
    CGFloat interpreterViewH = kWebViewHeight;
    CGRect frame = CGRectMake(interpreterViewX, interpreterViewY, interpreterViewW, interpreterViewH);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.interpreterView.frame = frame;
    } completion:^(BOOL finished) {
        [self.interpreterView interpretWithText:text];
    }];
}

- (void)hiddenInterpreterView {
    CGFloat interpreterViewX = 0.0;
    CGFloat interpreterViewY = CGRectGetHeight(self.view.frame);
    CGFloat interpreterViewW = CGRectGetWidth(self.view.frame);
    CGFloat interpreterViewH = kWebViewHeight;
    CGRect frame = CGRectMake(interpreterViewX, interpreterViewY, interpreterViewW, interpreterViewH);
    
    if (!_interpreterView) {
        [self.view addSubview:self.interpreterView];
        self.interpreterView.frame = frame;
    } else {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.interpreterView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark -- getter
- (InterpreterView *)interpreterView {
    if (!_interpreterView) {
        _interpreterView = [[InterpreterView alloc] init];
        _interpreterView.delegate = self;
    }
    
    return _interpreterView;
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
