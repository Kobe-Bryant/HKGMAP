//
//  Feedback.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-18.
//
//

#import "Feedback.h"
#import "WebAPI.h"

@implementation Feedback

- (Result *)save
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.email forKey:@"email"];
    [params setObject:self.message forKey:@"content"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"feedback.html" params:params];
    Result *result = [webAPI post:nil];
    
    return result;
}

@end
