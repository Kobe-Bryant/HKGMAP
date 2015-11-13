//
//  ProductGallery.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-1.
//
//

#import "ProductGallery.h"
#import "WebAPI.h"

@implementation ProductGallery

+ (Result *)requestList:(NSNumber *)productId offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[productId stringValue] forKey:@"productId"];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];

    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getProductGalleryList.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *productGalleryArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                ProductGallery *productGallery = [[ProductGallery alloc] init];
                if ([infoDict objectForKey:@"id"]) {
                    productGallery.productGalleryID = [infoDict objectForKey:@"id"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    productGallery.imageURLString = [infoDict objectForKey:@"photo2x"];
                } else {
                    productGallery.imageURLString = [infoDict objectForKey:@"photo"];
                }
                if ([infoDict objectForKey:@"title"]) {
                    productGallery.title = [infoDict objectForKey:@"title"];
                }
                [productGalleryArray addObject:productGallery];
            }
            return productGalleryArray;
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
        self.productGalleryID = [decoder decodeObjectForKey:@"productGalleryID"];
        self.productID = [decoder decodeObjectForKey:@"productID"];
        self.imageURLString = [decoder decodeObjectForKey:@"imageUrlString"];
        self.title = [decoder decodeObjectForKey:@"title"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.productGalleryID forKey:@"productGalleryID"];
    [encoder encodeObject:self.productID forKey:@"productID"];
    [encoder encodeObject:self.imageURLString forKey:@"imageUrlString"];
    [encoder encodeObject:self.title forKey:@"title"];
}

@end
