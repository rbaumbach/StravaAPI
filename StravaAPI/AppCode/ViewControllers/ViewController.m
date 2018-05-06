#import <AFNetworking/AFNetworking.h>
#import "ViewController.h"
#import "StravaAPI.h"
#import "StravaAPIAFClient.h"
#import "Athlete.h"

@interface ViewController()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) id<StravaAPI> client;
@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.client = [[StravaAPIAFClient alloc] init];
    
    [self.client getAthelete:@"26492009"
                     success:^(Athlete *athlete) {
                         [self removeActivityIndicator];
                         
                         [self loadAthlete:athlete];
                     } failure:^(NSError *error) {
                         [self removeActivityIndicator];
                         
                         [self loadError];
                     }];
}

#pragma mark - Private Methods

- (void)removeActivityIndicator {
    [self.activityIndicatorView stopAnimating];
}

- (void)loadAthlete:(Athlete *)athlete {
    self.avatarImageView.hidden = NO;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", athlete.firstName, athlete.lastName];
    self.nameLabel.hidden = NO;
    
    self.emailLabel.text = athlete.email;
    self.emailLabel.hidden = NO;
}

- (void)loadError {
    self.errorLabel.hidden = YES;
}

@end
