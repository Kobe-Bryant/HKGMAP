//
//  Setting.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-25.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface SystemSetting : NSObject

@property (nonatomic, retain) NSString *version;
@property (nonatomic, retain) NSString *updateVersionURLString;

+ (Result *)versionInformation;

@end
