//
//  MerchantType.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-17.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface MerchantType : NSObject<NSCoding>

@property (nonatomic, retain) NSNumber *merchantTypeID;
@property (nonatomic, retain) NSString *name;

+ (Result *)requestList:(NSInteger)offset limit:(NSInteger)limit;

@end
