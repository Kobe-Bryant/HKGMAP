//
//  Store.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-17.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Discount.h"

@interface Store : NSObject

@property (nonatomic, retain) NSNumber *storeID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *traffic;
@property (nonatomic, retain) NSString *contact;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSArray *discountArray;
@property (nonatomic, retain) NSString *logoImageURLString;


+ (Result *)requestList:(NSNumber *)merchantID discountID:(NSNumber *)discountID offset:(NSInteger)offset limit:(NSInteger)limit;

@end
