//
//  ProductGallery.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-1.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface ProductGallery : NSObject<NSCoding>

@property (nonatomic, retain) NSNumber *productGalleryID;
@property (nonatomic, retain) NSNumber *productID;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *title;

+ (Result *)requestList:(NSNumber *)productId offset:(NSInteger)offset limit:(NSInteger)limit;

@end
