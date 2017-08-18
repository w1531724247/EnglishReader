#import "WKDetailViewController.h"
#import "WKDocumentInfoViewController.h"

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
		[coreTextView setAttributedText:self.detailItem];
        
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
