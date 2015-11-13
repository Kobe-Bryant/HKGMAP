//
//  DiscountGallery.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-1.
//
//

#import "DiscountGallery.h"

@implementation DiscountGallery

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.discountGalleryID = [decoder decodeObjectForKey:@"discountGalleryID"];
        self.discountID = [decoder decodeObjectForKey:@"discountID"];
        self.imageURLString = [decoder decodeObjectForKey:@"imageUrlString"];
        self.title = [decoder decodeObjectForKey:@"title"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.discountGalleryID forKey:@"discountGalleryID"];
    [encoder encodeObject:self.discountID forKey:@"discountID"];
    [encoder encodeObject:self.imageURLString forKey:@"imageUrlString"];
    [encoder encodeObject:self.title forKey:@"title"];
}

@end
