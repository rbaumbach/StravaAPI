#import <WebKit/WebKit.h>
#import <AFNetworking/AFNetworking.h>
#import "ViewController.h"
#import "StravaAPI.h"
#import "StravaAPIAFClient.h"

@interface ViewController()
@property (strong, nonatomic) id<StravaAPI> client;
@property (weak, nonatomic) IBOutlet WKWebView *webKitView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.client = [[StravaAPIAFClient alloc] init];
    
    [self.client getAthelete:@"26492009"
                     success:^(Athlete *athlete) {
                         NSLog(@"%@", athlete);
                     } failure:^(NSError *error) {
                         NSLog(@"%@", error);
                     }];
}

@end
