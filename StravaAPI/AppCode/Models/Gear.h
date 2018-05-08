#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GearType) {
    GearTypeBike,
    GearTypeRunningShoes
};

@interface Gear : NSObject

@property (copy, nonatomic) NSString *gearID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *brandName;
@property (nonatomic) GearType gearType;

@end
