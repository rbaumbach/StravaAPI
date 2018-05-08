#import <AFNetworking/AFNetworking.h>
#import "StravaAPIAFClient.h"
#import "StravaConstants.h"
#import "AthleteDeserializer.h"
#import "Athlete.h"
#import "Gear.h"

@interface StravaAPIAFClient()
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@end

@implementation StravaAPIAFClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSessionManager];
    }
    return self;
}

#pragma mark - <StravaAPI>

- (void)getAthelete:(NSString *)atheleteID
            success:(void (^)(Athlete *athlete))success
            failure:(void (^)(NSError *error))failure {
    NSString *endpointString = [NSString stringWithFormat:@"athletes/%@", atheleteID];
    
    [self get:endpointString success:^(id response) {
        AthleteDeserializer *deserializer = [[AthleteDeserializer alloc] init];
        Athlete *athlete = [deserializer deserialize:response];
        
        [self getGearDetailsForAthlete:athlete success:^{
            success(athlete);
        } failure:failure];
        
    } failure:failure];
}

- (void)getGear:(NSString *)gearID
        success:(void (^)(Gear *gear))success
        failure:(void (^)(NSError *error))failure
{
    NSString *endpointString = [NSString stringWithFormat:@"gear/%@", gearID];
    
    [self get:endpointString success:^(id response) {
        Gear *gear = [[Gear alloc] init];
        
        gear.brandName = response[@"brand_name"];
        
        success(gear);
    } failure:failure];
}

#pragma mark - Private Methods

- (void)setupSessionManager {
    self.sessionManager = [AFHTTPSessionManager manager];
    
    NSString *accessTokenHeaderValue = [NSString stringWithFormat:@"Bearer %@", StravaAccessToken];
    
    [self.sessionManager.requestSerializer setValue:accessTokenHeaderValue
                                 forHTTPHeaderField:@"Authorization"];
}

- (void)get:(NSString *)endpoint success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", StravaEndointURLString, endpoint];
    
    [self.sessionManager GET:urlString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         success(responseObject);
                     } failure:^(NSURLSessionTask *operation, NSError *error) {
                         failure(error);
                     }];
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
