//
//  Product.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-7.
//
//

#import "Product.h"
#import "WebAPI.h"

@implementation Product

+ (Result *)requestList:(NSNumber *)merchantID offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[merchantID stringValue] forKey:@"merchantId"];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getProductList.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *productArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Product *product = [[Product alloc] init];
                if ([infoDict objectForKey:@"id"]) {
                    product.productID = [infoDict objectForKey:@"id"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    product.imageURLString = [infoDict objectForKey:@"photo2x"];
                } else {
                    product.imageURLString = [infoDict objectForKey:@"photo"];
                }
                if ([infoDict objectForKey:@"title"]) {
                    product.title = [infoDict objectForKey:@"title"];
                }
                [productArray addObject:product];
            }
            return productArray;
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
        self.productID = [decoder decodeObjectForKey:@"productID"];
        self.imageURLString = [decoder decodeObjectForKey:@"imageUrlString"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.productID forKey:@"productID"];
    [encoder encodeObject:self.imageURLString forKey:@"imageUrlString"];
}

@end
