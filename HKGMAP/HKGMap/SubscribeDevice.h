//
//  SubscribeDevice.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-18.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface SubscribeDevice : NSObject<NSCoding>

@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, readwrite) BOOL isSubscribe;

- (void)sync;

@end
