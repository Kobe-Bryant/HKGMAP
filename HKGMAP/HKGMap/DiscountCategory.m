//
//  DiscountCategory.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-28.
//
//

#import "DiscountCategory.h"
#import "WebAPI.h"

@implementation DiscountCategory

+ (Result *)requestList:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];

    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getFavourableCategoryList.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *discountCategoryArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                DiscountCategory *discountCategory = [[DiscountCategory alloc] init];
                if ([infoDict objectForKey:@"id"]) {
                    discountCategory.discountCategoryID = [infoDict objectForKey:@"id"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    discountCategory.imageURLString = [infoDict objectForKey:@"photo2x"];
                } else {
                    discountCategory.imageURLString = [infoDict objectForKey:@"photo"];
                }
                if ([infoDict objectForKey:@"title"]) {
                    discountCategory.title = [infoDict objectForKey:@"title"];
                }
                [discountCategoryArray addObject:discountCategory];
            }
            return discountCategoryArray;
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
        self.discountCategoryID = [decoder decodeObjectForKey:@"discountCategoryID"];
        self.imageURLString = [decoder decodeObjectForKey:@"imageURLString"];
        self.title = [decoder decodeObjectForKey:@"title"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.discountCategoryID forKey:@"discountCategoryID"];
    [encoder encodeObject:self.imageURLString forKey:@"imageURLString"];
    [encoder encodeObject:self.title forKey:@"title"];
}

@end
