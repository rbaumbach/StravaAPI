#import <Foundation/Foundation.h>

@class Athlete;

@protocol StravaAPI

- (void)getAthelete:(NSString *)atheleteID
            success:(void (^)(Athlete *athlete))success
            failure:(void (^)(NSError *error))failure;

@end
