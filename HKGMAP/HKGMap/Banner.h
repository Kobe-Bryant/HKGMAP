//
//  Banner.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-28.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface Banner : NSObject<NSCoding>

@property (nonatomic, retain) NSNumber *bannerID;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, readwrite) NSNumber *productID;
@property (nonatomic, retain) NSString *linkURLString;

+ (Result *)requestBannerList:(NSInteger)offset limit:(NSInteger)limit;
+ (Result *)requestAdvertisementList:(NSInteger)offset limit:(NSInteger)limit;

@end
