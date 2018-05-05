#import <Foundation/Foundation.h>

@interface StravaAPIClient : NSObject

- (void)getAthelete:(NSString *)atheleteID
            success:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure;

@end
