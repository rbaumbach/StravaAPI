#import "AthleteDeserializer.h"
#import "Athlete.h"

@implementation AthleteDeserializer

- (Athlete *)deserialize:(NSDictionary *)response {
    Athlete *athlete = [[Athlete alloc] init];
    
    athlete.firstName = response[@"firstName"];
    athlete.lastName = response[@"lastName"];
    athlete.email = response[@"email"];
    
    return athlete;
}

@end
