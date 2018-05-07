#import "AthleteDeserializer.h"
#import "Athlete.h"

@implementation AthleteDeserializer

- (Athlete *)deserialize:(NSDictionary *)response {
    Athlete *athlete = [[Athlete alloc] init];
    
    // Note: avatarURL for the athlete is ignored for now since the URL given back from the athlete
    //       endpoint is not the full URL.  I'm assuming this is because I'm using token athentication
    //       and public profile images shouldn't be given so easily.
    
    athlete.firstName = response[@"firstname"];
    athlete.lastName = response[@"lastname"];
    athlete.email = response[@"email"];
    
    return athlete;
}

@end
