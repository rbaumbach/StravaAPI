#import <Foundation/Foundation.h>

@class Athlete;

@interface AthleteDeserializer : NSObject

- (Athlete *)deserialize:(NSDictionary *)response;

@end
