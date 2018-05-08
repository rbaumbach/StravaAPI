#import <Foundation/Foundation.h>

@class Gear;

@interface Athlete : NSObject

@property (copy, nonatomic) NSString *athleteID;
@property (copy, nonatomic) NSURL *avatarURL;
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSArray<Gear *> *bikes;
@property (copy, nonatomic) NSArray<Gear *> *runningShoes;

@end
