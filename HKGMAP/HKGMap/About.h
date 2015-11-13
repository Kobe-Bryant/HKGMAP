//
//  About.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-25.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface About : NSObject<NSCoding>

@property (nonatomic, retain) NSString *slug;
@property (nonatomic, retain) NSString *contents;

+ (Result *)requestOne:(NSString *)slug;

@end
