#import "WKDetailViewController.h"
#import "WKDocumentInfoViewController.h"
#import "YYKit.h"

@interface WKDetailViewController ()
- (void)configureView;
@end

@implementation WKDetailViewController

@synthesize detailItem = _detailItem, documentInfo;

- (void)dealloc
{
	
    
}

- (void)setDetailItem:(id)newDetailItem
{
    _detailItem = newDetailItem;
    
    [self configureView];
}


- (void)configureView
{
	if (self.detailItem) {
        NSMutableAttributedString *attString = (NSMutableAttributedString *)self.detailItem;
        NSString *abString = attString.string;
        NSInteger length = attString.length;
        
        NSMutableArray *rangeArray = [NSMutableArray array];
        int preIndex = 0;
        for (int index = 0; index < length; index++) {
            NSString *substring = [abString substringWithRange:NSMakeRange(index, 1)];
            if ([substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
                [rangeArray addObject:[NSValue valueWithRange:NSMakeRange(preIndex, index-preIndex)]];
                preIndex = index;
            }
        }
        
        NSMutableAttributedString *actionText = [[NSMutableAttributedString alloc] init];
        for (NSValue *value in rangeArray) {
            NSRange range = [value rangeValue];
            NSMutableAttributedString *subAttString = [[NSMutableAttributedString alloc] initWithAttributedString:[attString attributedSubstringFromRange:range]];
            [subAttString setTextHighlightRange:subAttString.rangeOfAll color:nil backgroundColor:[UIColor blueColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                NSLog(@"tapText = %@", [text attributedSubstringFromRange:range].string);
            }];
            
            [actionText appendAttributedString:subAttString];
            [actionText appendString:@" "];
        }

		[coreTextView setAttributedText:actionText];
        
//        UILabel *textLabel = [[UILabel alloc] init];
//        [textLabel setAttributedText:self.detailItem];
//        [self.view addSubview:textLabel];
//        CGFloat textLabelX = ;
//        CGFloat textLabelY = ;
//        CGFloat textLabelW = ;
//        CGFloat textLabelH = ;
//        textLabel.frame = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	coreTextView = [[YYTextView alloc] initWithFrame:self.view.bounds];
    coreTextView.editable = NO;
	[self.view addSubview:coreTextView];
    CGRect frame = coreTextView.frame;
    frame.origin.y += 64.0;
    coreTextView.frame =  frame;
    
    self.navigationItem.rightBarButtonItem = infoButton;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

-(void)viewDocumentInfo:(id)sender
{
	WKDocumentInfoViewController *documentInfoController = [[WKDocumentInfoViewController alloc] init];
	[documentInfoController setDictionary:documentInfo];
	[self presentModalViewController:documentInfoController animated:YES];
}
							
@end
