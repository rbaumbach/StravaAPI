#import <AFNetworking/AFNetworking.h>
#import "StravaAPIAFClient.h"
#import "StravaConstants.h"
#import "AthleteDeserializer.h"

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

- (void)getAthelete:(NSString *)atheleteID
            success:(void (^)(Athlete *athlete))success
            failure:(void (^)(NSError *error))failure {
    NSString *endpointString = [NSString stringWithFormat:@"athletes/%@", atheleteID];
    
    [self get:endpointString success:^(id response) {
        NSLog(@"%@", response);
        
        AthleteDeserializer *deserializer = [[AthleteDeserializer alloc] init];
        Athlete *athlete = [deserializer deserialize:response];
        
        success(athlete);
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

@end
