//
//  Feedback.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-18.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface Feedback : NSObject

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *message;

- (Result *)save;

@end
