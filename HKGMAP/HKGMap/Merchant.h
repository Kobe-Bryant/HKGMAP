//
//  Merchant.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-17.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Result.h"
#import "DiscountGallery.h"
#import "Discount.h"

@interface Merchant : NSObject<NSCoding>

@property (nonatomic, retain) NSNumber *merchantID;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *merchantName;
@property (nonatomic, retain) NSNumber *storeID;
@property (nonatomic, retain) NSString *storeName;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *nearbyRadius;
@property (nonatomic, retain) NSString *merchantSummary;
@property (nonatomic, retain) NSString *merchantCategoryName;
@property (nonatomic, retain) NSString *businessDistrictName;
@property (nonatomic, retain) NSString *merchantTypeName;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *traffic;
@property (nonatomic, retain) NSString *contact;
@property (nonatomic, retain) NSNumber *productCount;
@property (nonatomic, retain) NSNumber *storeCount;
@property (nonatomic, readwrite) BOOL hasCollect;
@property (nonatomic, retain) NSArray *discountArray;
@property (nonatomic, retain) NSArray *merchantGalleryArray;

+ (Result *)requestList:(NSString *)searchKeyword currentCoordinate:(CLLocationCoordinate2D)currentCoordinate nearbyRadius:(CGFloat)nearbyRadius businessDistrictID:(NSNumber *)businessDistrictID merchantTypeID:(NSNumber *)merchantTypeID offset:(NSInteger)offset limit:(NSInteger)limit;
+ (Result *)requestListAtMap:(NSString *)searchKeyword currentCoordinate:(CLLocationCoordinate2D)currentCoordinate nearbyRadius:(CGFloat)nearbyRadius businessDistrictID:(NSNumber *)businessDistrictID merchantTypeID:(NSNumber *)merchantTypeID offset:(NSInteger)offset limit:(NSInteger)limit;

+ (Result *)requestOne:(NSNumber *)memberID merchantID:(NSNumber *)merchantID;

@end
