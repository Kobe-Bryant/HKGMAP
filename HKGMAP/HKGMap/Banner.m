//
//  Banner.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-28.
//
//

#import "Banner.h"
#import "WebApi.h"

@implementation Banner

+ (Result *)requestBannerList:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getBannerList.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"bannerList"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"bannerList"];
            NSMutableArray *bannerArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Banner *banner = [[Banner alloc] init];
                if ([infoDict objectForKey:@"id"]) {
                    banner.bannerID = [infoDict objectForKey:@"id"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    banner.imageURLString = [infoDict objectForKey:@"photo2x"];
                } else {
                    banner.imageURLString = [infoDict objectForKey:@"photo"];
                }
                if ([infoDict objectForKey:@"title"]) {
                    banner.title = [infoDict objectForKey:@"title"];
                }
                if ([infoDict objectForKey:@"productId"]) {
                    banner.productID = [infoDict objectForKey:@"productId"];
                }
                [bannerArray addObject:banner];
            }
            return bannerArray;
        }
        
        return nil;
    }];
    
    return result;
}

+ (Result *)requestAdvertisementList:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"4" forKey:@"type"];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getBannerList.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"bannerList"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"bannerList"];
            NSMutableArray *bannerArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Banner *banner = [[Banner alloc] init];
                if ([infoDict objectForKey:@"id"]) {
                    banner.bannerID = [infoDict objectForKey:@"id"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    banner.imageURLString = [infoDict objectForKey:@"photo2x"];
                } else {
                    banner.imageURLString = [infoDict objectForKey:@"photo"];
                }
                if ([infoDict objectForKey:@"title"]) {
                    banner.title = [infoDict objectForKey:@"title"];
                }
                if ([infoDict objectForKey:@"productId"]) {
                    banner.productID = [infoDict objectForKey:@"productId"];
                }
                if ([infoDict objectForKey:@"url"]) {
                    banner.linkURLString = [infoDict objectForKey:@"url"];
                }
                [bannerArray addObject:banner];
            }
            return bannerArray;
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
        self.bannerID = [decoder decodeObjectForKey:@"bannerID"];
        self.imageURLString = [decoder decodeObjectForKey:@"imageURLString"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.productID = [decoder decodeObjectForKey:@"productID"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.bannerID forKey:@"bannerID"];
    [encoder encodeObject:self.imageURLString forKey:@"imageURLString"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.productID forKey:@"productID"];
}

@end
