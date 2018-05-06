#import <Foundation/Foundation.h>
#import "StravaAPI.h"

@class Athlete;

@interface StravaAPIAFClient : NSObject <StravaAPI>

- (void)getAthelete:(NSString *)atheleteID
            success:(void (^)(Athlete *athlete))success
            failure:(void (^)(NSError *error))failure;

@end
