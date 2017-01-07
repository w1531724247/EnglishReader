//
//  ArticleDetailViewController.m
//  EnglishReader
//
//  Created by QMTV on 17/1/7.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArticleHelper.h"

@interface ArticleDetailViewController ()
@property (nonatomic, strong) ArticleHelper *articleHleper;
@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demoText" ofType:@"txt"];
    NSArray *array = [self.articleHleper analyseArticleWithFilePath:filePath];
    
    NSString *articleText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    for (NSValue *value in array) {
        NSRange range = [value rangeValue];
        NSString *text = [articleText substringWithRange:range];
        
        NSLog(@"-%@-", text);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- getter

- (ArticleHelper *)articleHleper {
    if (!_articleHleper) {
        _articleHleper = [[ArticleHelper alloc] init];
    }
    
    return _articleHleper;
}
@end
