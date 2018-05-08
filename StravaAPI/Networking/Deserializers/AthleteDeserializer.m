#import "AthleteDeserializer.h"
#import "Athlete.h"
#import "Gear.h"

@implementation AthleteDeserializer

- (Athlete *)deserialize:(NSDictionary *)response {
    Athlete *athlete = [[Athlete alloc] init];
    
    // Note: avatarURL for the athlete is ignored for now since the URL given back from the athlete
    //       endpoint is not the full URL.  I'm assuming this is because I'm using token athentication
    //       and public profile images shouldn't be given so easily.
    
    athlete.athleteID = response[@"id"];
    athlete.firstName = response[@"firstname"];
    athlete.lastName = response[@"lastname"];
    athlete.email = response[@"email"];
    
    athlete.bikes = [self deserializeBikes:response[@"bikes"]];
    athlete.runningShoes = [self deserializeRunningShoes:response[@"shoes"]];
    
    return athlete;
}

- (NSArray<Gear *> *)deserializeBikes:(NSArray *)responseBikes {
    NSMutableArray<Gear *> *deserializedBikes = [@[] mutableCopy];
    
    for (NSDictionary *bikeDict in responseBikes) {
        Gear *gear = [[Gear alloc] init];
        
        gear.gearID = bikeDict[@"id"];
        gear.name = bikeDict[@"name"];
        gear.gearType = GearTypeBike;
        
        [deserializedBikes addObject:gear];
    }
    
    return [deserializedBikes copy];
}

- (NSArray<Gear *> *)deserializeRunningShoes:(NSArray *)responseRunningShones {
    NSMutableArray<Gear *> *deserializedRunningShoes = [@[] mutableCopy];
    
    for (NSDictionary *runningShoesDict in responseRunningShones) {
        Gear *gear = [[Gear alloc] init];
        
        gear.gearID = runningShoesDict[@"id"];
        gear.name = runningShoesDict[@"name"];
        gear.gearType = GearTypeRunningShoes;
        
        [deserializedRunningShoes addObject:gear];
    }
    
    return [deserializedRunningShoes copy];
}

@end
