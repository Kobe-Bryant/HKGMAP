//
//  Discount.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-31.
//
//

#import "Discount.h"
#import "WebAPI.h"

@implementation Discount

- (NSString *)startEndDateString
{
    NSDateComponents *startDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self startDate]];
    NSDateComponents *endDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self endDate]];

    if ([startDateComponents year] == [endDateComponents year]
        && [startDateComponents month] == [endDateComponents month]
        && [startDateComponents day] == [endDateComponents day]) {
        return [[NSString alloc] initWithFormat:@"%i年%i月%i日", [startDateComponents year], [startDateComponents month], [startDateComponents day]];
    } else if ([startDateComponents year] == [endDateComponents year]
        && [startDateComponents month] == [endDateComponents month]) {
        return [[NSString alloc] initWithFormat:@"%i年%i月%i日 至 %i日", [startDateComponents year], [startDateComponents month], [startDateComponents day], [endDateComponents day]];
    } else if ([startDateComponents year] == [endDateComponents year]) {
        return [[NSString alloc] initWithFormat:@"%i年%i月%i日 至 %i月%i日", [startDateComponents year], [startDateComponents month], [startDateComponents day], [endDateComponents month], [endDateComponents day]];
    } else {
        return [[NSString alloc] initWithFormat:@"%i年%i月%i日 至 %i年%i月%i日", [startDateComponents year], [startDateComponents month], [startDateComponents day], [endDateComponents year], [endDateComponents month], [endDateComponents day]];
    }

    return nil;
}

+ (Result *)requestList:(NSDate *)startDate endDate:(NSDate *)endDate dateFormatter:(NSDateFormatter *)dateFormatter discountCategoryID:(NSNumber *)discountCategoryID offset:(NSInteger)offset limit:(NSInteger)limit;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (startDate != nil) {
        [params setObject:[dateFormatter stringFromDate:startDate] forKey:@"startDate"];
    } else {
        [params setObject:@"" forKey:@"startDate"];
    }
    if (endDate != nil) {
        [params setObject:[dateFormatter stringFromDate:endDate] forKey:@"endDate"];
    } else {
        [params setObject:@"" forKey:@"endDate"];
    }
    [params setObject:[discountCategoryID stringValue] forKey:@"categoryId"];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];

    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getFavourableList.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *discountArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Discount *discount = [[Discount alloc] init];
                if ([infoDict objectForKey:@"id"]) {
                    discount.discountID = [infoDict objectForKey:@"id"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    discount.imageURLString = [infoDict objectForKey:@"photo2x"];
                } else {
                    discount.imageURLString = [infoDict objectForKey:@"photo"];
                }
                if ([infoDict objectForKey:@"title"]) {
                    discount.title = [infoDict objectForKey:@"title"];
                }
                if ([infoDict objectForKey:@"startTime"]) {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    discount.startDate = [dateFormatter dateFromString:[infoDict objectForKey:@"startTime"]];
                }
                if ([infoDict objectForKey:@"endTime"]) {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    discount.endDate = [dateFormatter dateFromString:[infoDict objectForKey:@"endTime"]];
                }
                if ([infoDict objectForKey:@"hasCoupon"]) {
                    discount.hasCoupon = [[infoDict objectForKey:@"hasCoupon"] boolValue];
                }
                if ([infoDict objectForKey:@"isFavorite"]) {
                    discount.hasDiscount = [[infoDict objectForKey:@"isFavorite"] boolValue];
                }
                [discountArray addObject:discount];
            }
            return discountArray;
        }
        
        return nil;
    }];
    
    return result;
}

+ (Result *)requestOne:(NSNumber *)memberID discountID:(NSNumber *)discountID
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[memberID stringValue] forKey:@"memberId"];
    [params setObject:[discountID stringValue] forKey:@"favourableId"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getFavourableDetail.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        Discount *discount = [[Discount alloc] init];
        if ([responseObject objectForKey:@"detail"]) {
            NSDictionary *infoDict = [responseObject objectForKey:@"detail"];

            if ([infoDict objectForKey:@"id"]) {
                discount.discountID = [infoDict objectForKey:@"id"];
            }
            if ([[UIScreen mainScreen] scale] == 2.0) {
                discount.imageURLString = [infoDict objectForKey:@"photo2x"];
            } else {
                discount.imageURLString = [infoDict objectForKey:@"photo"];
            }
            if ([infoDict objectForKey:@"title"]) {
                discount.title = [infoDict objectForKey:@"title"];
            }
            if ([infoDict objectForKey:@"startTime"]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                discount.startDate = [dateFormatter dateFromString:[infoDict objectForKey:@"startTime"]];
            }
            if ([infoDict objectForKey:@"endTime"]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                discount.endDate = [dateFormatter dateFromString:[infoDict objectForKey:@"endTime"]];
            }
            if ([infoDict objectForKey:@"hasCoupon"]) {
                discount.hasCoupon = [[infoDict objectForKey:@"hasCoupon"] boolValue];
            }
            if ([infoDict objectForKey:@"isFavorite"]) {
                discount.hasDiscount = [[infoDict objectForKey:@"isFavorite"] boolValue];
            }
            if ([infoDict objectForKey:@"isCollect"]) {
                discount.hasCollect = [[infoDict objectForKey:@"isCollect"] boolValue];
            }
            if ([infoDict objectForKey:@"merchantCount"]) {
                discount.merchantCount = [infoDict objectForKey:@"merchantCount"];
            }
            if ([infoDict objectForKey:@"content"]) {
                discount.contents = [infoDict objectForKey:@"content"];
            }
            if ([infoDict objectForKey:@"gallery"]) {
                NSDictionary *galleryListDict = [infoDict objectForKey:@"gallery"];
                NSMutableArray *discountGalleryArray = [[NSMutableArray alloc] init];
                for (NSDictionary *galleryDict in galleryListDict) {
                    DiscountGallery *discountGallery = [[DiscountGallery alloc] init];
                    if ([galleryDict objectForKey:@"id"]) {
                        discountGallery.discountGalleryID = [galleryDict objectForKey:@"id"];
                    }
                    if ([[UIScreen mainScreen] scale] == 2.0) {
                        discountGallery.imageURLString = [galleryDict objectForKey:@"photo2x"];
                    } else {
                        discountGallery.imageURLString = [galleryDict objectForKey:@"photo"];
                    }
                    if ([galleryDict objectForKey:@"title"]) {
                        discountGallery.title = [galleryDict objectForKey:@"title"];
                    }
                    [discountGalleryArray addObject:discountGallery];
                }
                discount.discountGalleryArray = discountGalleryArray;
            }
            
            return discount;
        }
        
        return nil;
    }];
    
    return result;
}

+ (Result *)requestCalendar:(NSDate *)startDate endDate:(NSDate *)endDate dateFormatter:(NSDateFormatter *)dateFormatter
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (startDate != nil) {
        [params setObject:[dateFormatter stringFromDate:startDate] forKey:@"startDate"];
    } else {
        [params setObject:@"" forKey:@"startDate"];
    }
    if (endDate != nil) {
        [params setObject:[dateFormatter stringFromDate:endDate] forKey:@"endDate"];
    } else {
        [params setObject:@"" forKey:@"endDate"];
    }

    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getActivityCalendarList.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSArray *dateStringArray = (NSArray *)[responseObject objectForKey:@"list"];
            NSMutableArray *dateArray = [[NSMutableArray alloc] init];
            for (NSString *dateString in dateStringArray) {
                NSDate *date = [dateFormatter dateFromString:dateString];
                if (date != nil) {
                    [dateArray addObject:date];
                }
            }
                                         
            return dateArray;
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
        self.discountID = [decoder decodeObjectForKey:@"discountID"];
        self.discountCategoryID = [decoder decodeObjectForKey:@"discountCategoryID"];
        self.imageURLString = [decoder decodeObjectForKey:@"imageURLString"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.startDate = [decoder decodeObjectForKey:@"startDate"];
        self.endDate = [decoder decodeObjectForKey:@"endDate"];
        self.hasCoupon = [[decoder decodeObjectForKey:@"hasCoupon"] boolValue];
        self.hasDiscount = [[decoder decodeObjectForKey:@"hasDiscount"] boolValue];
        self.hasCollect = [[decoder decodeObjectForKey:@"hasCollect"] boolValue];
        self.merchantCount = [decoder decodeObjectForKey:@"merchantCount"];
        self.contents = [decoder decodeObjectForKey:@"contents"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.discountID forKey:@"discountID"];
    [encoder encodeObject:self.discountCategoryID forKey:@"discountCategoryID"];
    [encoder encodeObject:self.imageURLString forKey:@"imageURLString"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.startDate forKey:@"startDate"];
    [encoder encodeObject:self.endDate forKey:@"endDate"];
    [encoder encodeObject:[NSNumber numberWithBool:self.hasCoupon] forKey:@"hasCoupon"];
    [encoder encodeObject:[NSNumber numberWithBool:self.hasDiscount] forKey:@"hasDiscount"];
    [encoder encodeObject:[NSNumber numberWithBool:self.hasCollect] forKey:@"hasCollect"];
    [encoder encodeObject:self.merchantCount forKey:@"merchantCount"];
    [encoder encodeObject:self.contents forKey:@"contents"];
}

@end
