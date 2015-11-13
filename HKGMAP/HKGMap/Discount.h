//
//  Discount.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-31.
//
//

#import <Foundation/Foundation.h>
#import "DiscountGallery.h"
#import "Result.h"

@interface Discount : NSObject<NSCoding>

@property (nonatomic, retain) NSNumber *discountID;
@property (nonatomic, retain) NSNumber *discountCategoryID;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, readwrite) BOOL hasCoupon;
@property (nonatomic, readwrite) BOOL hasDiscount;
@property (nonatomic, readwrite) BOOL hasCollect;
@property (nonatomic, retain) NSNumber *merchantCount;
@property (nonatomic, retain) NSString *contents;
@property (nonatomic, retain) NSArray *discountGalleryArray;

- (NSString *)startEndDateString;
+ (Result *)requestList:(NSDate *)startDate endDate:(NSDate *)endDate dateFormatter:(NSDateFormatter *)dateFormatter discountCategoryID:(NSNumber *)discountCategoryID offset:(NSInteger)offset limit:(NSInteger)limit;
+ (Result *)requestOne:(NSNumber *)memberID discountID:(NSNumber *)discountID;
+ (Result *)requestCalendar:(NSDate *)startDate endDate:(NSDate *)endDate dateFormatter:(NSDateFormatter *)dateFormatter;



@end
