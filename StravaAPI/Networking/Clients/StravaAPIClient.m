#import "StravaAPIClient.h"
#import "StravaConstants.h"
#import "Athlete.h"
#import "AthleteDeserializer.h"
#import "Gear.h"

@interface StravaAPIClient()
@property (strong, nonatomic) NSURLSession *urlSession;
@end

@implementation StravaAPIClient

#pragma mark - Init Method

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupURLSession];
    }
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    NSLog(@"StravaAPIClient deallocated!");
}

#pragma mark - <StravaAPI>

- (void)getAthelete:(NSString *)atheleteID
            success:(void (^)(Athlete *))success
            failure:(void (^)(NSError *))failure {
    NSString *endpointString = [NSString stringWithFormat:@"athletes/%@", atheleteID];
    
    [self get:endpointString success:^(id response) {
        AthleteDeserializer *deserializer = [[AthleteDeserializer alloc] init];
        Athlete *athlete = [deserializer deserialize:response];
        
        [self getGearDetailsForAthlete:athlete success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                success(athlete);
                
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }];
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)getGear:(NSString *)gearID
        success:(void (^)(Gear *gear))success
        failure:(void (^)(NSError *error))failure {
    NSString *endpointString = [NSString stringWithFormat:@"gear/%@", gearID];
    
    [self get:endpointString success:^(id response) {
        Gear *gear = [[Gear alloc] init];

        gear.brandName = response[@"brand_name"];

        success(gear);
    } failure:failure];
}

#pragma mark - Private Methods

- (void)setupURLSession {
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
}

- (void)get:(NSString *)endpoint success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    NSURLRequest *urlRequest = [self buildURLRequest:endpoint];
    
    NSURLSessionDataTask *downloadTask = [self.urlSession dataTaskWithRequest:urlRequest
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                if (error) {
                                                                    failure(error);
                                                                }
                                                                
                                                                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                
                                                                success(jsonResponse);
                                                            }];
    
    [downloadTask resume];
}

- (NSURLRequest *)buildURLRequest:(NSString *)endpoint {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", StravaEndointURLString, endpoint];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *accessTokenHeaderValue = [NSString stringWithFormat:@"Bearer %@", StravaAccessToken];
    
    [urlRequest setValue:accessTokenHeaderValue forHTTPHeaderField:@"Authorization"];
    
    return [urlRequest copy];
}

- (void)getGearDetailsForAthlete:(Athlete *)athlete
                         success:(void (^)(void))success
                         failure:(void (^)(NSError *error))failure {
    NSArray<Gear *> *allGear = [athlete.bikes arrayByAddingObjectsFromArray:athlete.runningShoes];
    
    // Since we want to call success once we have all the gear, we will need to use dispatch_groups.
    // We will want to wait till all the gear calls have been successful.
    
    __block NSError *potentialError;
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    for (Gear *singleGear in allGear) {
        dispatch_group_enter(serviceGroup);
        
        [self getGear:singleGear.gearID
              success:^(Gear *gear) {
                  dispatch_group_leave(serviceGroup);
                  
                  singleGear.brandName = gear.brandName;
              } failure:^(NSError *error) {
                  potentialError = error;
              }];
    }
    
    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        if (potentialError) {
            failure(potentialError);
        } else {
            success();
        }
    });
}

@end
