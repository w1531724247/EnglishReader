#import <UIKit/UIKit.h>
#import "YYTextView.h"

@interface WKDetailViewController : UIViewController {
	YYTextView *coreTextView;
	IBOutlet UIBarButtonItem *infoButton;
}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSDictionary *documentInfo;

-(IBAction)viewDocumentInfo:(id)sender;

@end
