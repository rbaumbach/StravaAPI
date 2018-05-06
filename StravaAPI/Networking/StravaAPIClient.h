#import <Foundation/Foundation.h>

@class Athlete;

@interface StravaAPIClient : NSObject

- (void)getAthelete:(NSString *)atheleteID
            success:(void (^)(Athlete *athlete))success
            failure:(void (^)(NSError *error))failure;

@end
