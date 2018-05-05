#import <WebKit/WebKit.h>
#import <AFNetworking/AFNetworking.h>
#import "ViewController.h"
#import "StravaAPIClient.h"

@interface ViewController()
@property (strong, nonatomic) StravaAPIClient *client;
@property (weak, nonatomic) IBOutlet WKWebView *webKitView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.client = [[StravaAPIClient alloc] init];
    
    [self.client getAthelete:@"26492009"
                     success:^(id response) {
                         NSLog(@"%@", response);
                     } failure:^(NSError *error) {
                         NSLog(@"%@", error);
                     }];
}

@end
