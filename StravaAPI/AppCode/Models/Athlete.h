#import <Foundation/Foundation.h>

@interface Athlete : NSObject

@property (copy, nonatomic) NSURL *avatarURL;
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *email;

@end
