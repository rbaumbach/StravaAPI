#import <AFNetworking/AFNetworking.h>
#import "StravaAPIClient.h"
#import "StravaConstants.h"

@interface StravaAPIClient()
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@end

@implementation StravaAPIClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSessionManager];
    }
    return self;
}

- (void)getAthelete:(NSString *)atheleteID
            success:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure {
    NSString *urlString = [NSString stringWithFormat:@"https://www.strava.com/api/v3/athletes/%@", atheleteID];
    
    [self.sessionManager GET:urlString
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             success(responseObject);
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             failure(error);
         }];
}

#pragma mark - Private Methods

- (void)setupSessionManager {
    self.sessionManager = [AFHTTPSessionManager manager];
    
    NSString *accessTokenHeaderValue = [NSString stringWithFormat:@"Bearer %@", StravaAccessToken];
    
    [self.sessionManager.requestSerializer setValue:accessTokenHeaderValue
                                 forHTTPHeaderField:@"Authorization"];
}

@end
