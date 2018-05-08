#import <AFNetworking/AFNetworking.h>
#import "ViewController.h"
#import "StravaAPI.h"
#import "StravaAPIAFClient.h"
#import "StravaAPIClient.h"
#import "Athlete.h"
#import "Gear.h"

@interface ViewController()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *bikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningShoesLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) id<StravaAPI> client;
@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.client = [[StravaAPIAFClient alloc] init];
    //    self.client = [[StravaAPIClient alloc] init];
    
    // My athleteID: @"26492009"
    // Bike: @"b4784851"
    // Running Shoes: @"g3238861"
    
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
    
    self.bikeLabel.text = [NSString stringWithFormat:@"Bike brand: %@", ((Gear *)athlete.bikes[0]).brandName];
    self.bikeLabel.hidden = NO;
    
    self.runningShoesLabel.text = [NSString stringWithFormat:@"Running shoes brand: %@", ((Gear *)athlete.runningShoes[0]).brandName];
    self.runningShoesLabel.hidden = NO;
    
}

- (void)loadError {
    self.errorLabel.hidden = YES;
}

@end
