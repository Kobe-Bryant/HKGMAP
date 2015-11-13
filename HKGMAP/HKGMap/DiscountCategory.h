//
//  DiscountCategory.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-28.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface DiscountCategory : NSObject<NSCoding>

@property (nonatomic, retain) NSNumber *discountCategoryID;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *title;

+ (Result *)requestList:(NSInteger)offset limit:(NSInteger)limit;

@end
