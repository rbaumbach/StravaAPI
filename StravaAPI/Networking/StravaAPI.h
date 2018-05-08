#import <Foundation/Foundation.h>

@class Athlete;
@class Gear;

@protocol StravaAPI

- (void)getAthelete:(NSString *)atheleteID
            success:(void (^)(Athlete *athlete))success
            failure:(void (^)(NSError *error))failure;

- (void)getGear:(NSString *)gearID
        success:(void (^)(Gear *gear))success
        failure:(void (^)(NSError *error))failure;

@end
