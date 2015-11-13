//
//  Product.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-7.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface Product : NSObject<NSCoding>

@property (nonatomic, readwrite) NSNumber* productID;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *title;

+ (Result *)requestList:(NSNumber *)merchantID offset:(NSInteger)offset limit:(NSInteger)limit;

@end
