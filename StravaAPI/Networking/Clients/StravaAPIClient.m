#import "StravaAPIClient.h"
#import "StravaConstants.h"
#import "Athlete.h"
#import "AthleteDeserializer.h"

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

#pragma mark - <StravaAPI>

- (void)getAthelete:(NSString *)atheleteID
            success:(void (^)(Athlete *))success
            failure:(void (^)(NSError *))failure {
    NSString *endpointString = [NSString stringWithFormat:@"athletes/%@", atheleteID];
    
    [self get:endpointString success:^(id response) {
        AthleteDeserializer *deserializer = [[AthleteDeserializer alloc] init];
        Athlete *athlete = [deserializer deserialize:response];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(athlete);

        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
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

@end
