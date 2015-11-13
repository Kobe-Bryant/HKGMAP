//
//  About.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-25.
//
//

#import "About.h"
#import "WebAPI.h"

@implementation About

+ (Result *)requestOne:(NSString *)slug
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:slug forKey:@"type"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getPageContent.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"detail"]) {
            NSDictionary *dict = [responseObject objectForKey:@"detail"];
            About *about = [[About alloc] init];
            if ([dict objectForKey:@"content"]) {
                about.contents = [dict objectForKey:@"content"];
            }
            return about;
        }
        
        return nil;
    }];
    
    return result;
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.slug = [decoder decodeObjectForKey:@"slug"];
        self.contents = [decoder decodeObjectForKey:@"contents"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.slug forKey:@"slug"];
    [encoder encodeObject:self.contents forKey:@"contents"];
}



@end
