//
//  Result.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-25.
//
//

#import "Result.h"

@implementation Result

- (id)initWithSuccessData:(id)data
{
    self = [super init];
    if (self) {
        self.isSuccess = YES;
        self.data = data;
        self.error = nil;
        return self;
    }
    return nil;
}

- (id)initWithFailureError:(NSError *)error
{
    self = [super init];
    if (self) {
        self.isSuccess = NO;
        self.data = nil;
        self.error = error;
        return self;
    }
    return nil;
}

@end
