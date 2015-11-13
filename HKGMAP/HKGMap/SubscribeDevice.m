//
//  SubscribeDevice.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-18.
//
//

#import "SubscribeDevice.h"
#import "WebAPI.h"

@implementation SubscribeDevice

- (void)sync
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.deviceToken forKey:@"deviceToken"];
    [params setObject:[[NSNumber numberWithInteger:self.isSubscribe] stringValue] forKey:@"isSubscribe"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"sysnDeviceToken.html" params:params];
    [webAPI post:nil];
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.deviceToken = [decoder decodeObjectForKey:@"deviceToken"];
        self.isSubscribe = [[decoder decodeObjectForKey:@"isSubscribe"] boolValue];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isSubscribe] forKey:@"isSubscribe"];
}


@end
