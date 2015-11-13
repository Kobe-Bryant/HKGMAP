//
//  Merchant.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-17.
//
//

#import "Merchant.h"
#import "MerchantGallery.h"
#import "WebAPI.h"
#import <MapKit/MapKit.h>

@implementation Merchant

+ (Result *)requestList:(NSString *)searchKeyword currentCoordinate:(CLLocationCoordinate2D)currentCoordinate nearbyRadius:(CGFloat)nearbyRadius businessDistrictID:(NSNumber *)businessDistrictID merchantTypeID:(NSNumber *)merchantTypeID offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:searchKeyword forKey:@"keywords"];
    [params setObject:[[NSString alloc] initWithFormat:@"%f,%f", currentCoordinate.latitude, currentCoordinate.longitude] forKey:@"locationBase"];
    [params setObject:[[NSNumber numberWithFloat:nearbyRadius] stringValue] forKey:@"nearbyRadius"];
    [params setObject:[businessDistrictID stringValue] forKey:@"businessDistrictId"];
    [params setObject:[merchantTypeID stringValue] forKey:@"merchantTypeId"];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"searchMerchant.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *merchantArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Merchant *merchant = [[Merchant alloc] init];
                if ([infoDict objectForKey:@"merchantId"]) {
                    merchant.merchantID = [infoDict objectForKey:@"merchantId"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    merchant.imageURLString = [infoDict objectForKey:@"photo2x"];
                } else {
                    merchant.imageURLString = [infoDict objectForKey:@"photo"];
                }
                if ([infoDict objectForKey:@"merchantName"]) {
                    merchant.merchantName = [infoDict objectForKey:@"merchantName"];
                }
                if ([infoDict objectForKey:@"storeId"]) {
                    merchant.storeID = [infoDict objectForKey:@"storeId"];
                }
                if ([infoDict objectForKey:@"storeName"]) {
                    merchant.storeName = [infoDict objectForKey:@"storeName"];
                }
                if ([infoDict objectForKey:@"lat"] && [infoDict objectForKey:@"lng"]) {
                    merchant.coordinate = CLLocationCoordinate2DMake([[infoDict objectForKey:@"lat"] floatValue], [[infoDict objectForKey:@"lng"] floatValue]);
                }
                if ([infoDict objectForKey:@"nearbyRadius"]) {
                    merchant.nearbyRadius = [infoDict objectForKey:@"nearbyRadius"];
                }
                if ([infoDict objectForKey:@"merchantRemarks"]) {
                    merchant.merchantSummary = [infoDict objectForKey:@"merchantRemarks"];
                }
                if ([infoDict objectForKey:@"merchantCategoryName"]) {
                    merchant.merchantCategoryName = [infoDict objectForKey:@"merchantCategoryName"];
                }
                if ([infoDict objectForKey:@"businessDistrictName"]) {
                    merchant.businessDistrictName = [infoDict objectForKey:@"businessDistrictName"];
                }
                if ([infoDict objectForKey:@"merchantTypeName"]) {
                    merchant.merchantTypeName = [infoDict objectForKey:@"merchantTypeName"];
                }
                [merchantArray addObject:merchant];
            }
            return merchantArray;
        }
        
        return nil;
    }];
    
    return result;
}

+ (Result *)requestListAtMap:(NSString *)searchKeyword currentCoordinate:(CLLocationCoordinate2D)currentCoordinate nearbyRadius:(CGFloat)nearbyRadius businessDistrictID:(NSNumber *)businessDistrictID merchantTypeID:(NSNumber *)merchantTypeID offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:searchKeyword forKey:@"keywords"];
    [params setObject:[[NSString alloc] initWithFormat:@"%f,%f", currentCoordinate.latitude, currentCoordinate.longitude] forKey:@"locationBase"];
    [params setObject:[[NSNumber numberWithFloat:nearbyRadius] stringValue] forKey:@"nearbyRadius"];
    [params setObject:[businessDistrictID stringValue] forKey:@"businessDistrictId"];
    [params setObject:[merchantTypeID stringValue] forKey:@"merchantTypeId"];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"searchMerchantMap.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *merchantArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Merchant *merchant = [[Merchant alloc] init];
                if ([infoDict objectForKey:@"merchantId"]) {
                    merchant.merchantID = [infoDict objectForKey:@"merchantId"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    merchant.imageURLString = [infoDict objectForKey:@"photo2x"];
                } else {
                    merchant.imageURLString = [infoDict objectForKey:@"photo"];
                }
                if ([infoDict objectForKey:@"merchantName"]) {
                    merchant.merchantName = [infoDict objectForKey:@"merchantName"];
                }
                if ([infoDict objectForKey:@"storeId"]) {
                    merchant.storeID = [infoDict objectForKey:@"storeId"];
                }
                if ([infoDict objectForKey:@"storeName"]) {
                    merchant.storeName = [infoDict objectForKey:@"storeName"];
                }
                if ([infoDict objectForKey:@"lat"] && [infoDict objectForKey:@"lng"]) {
                    merchant.coordinate = CLLocationCoordinate2DMake([[infoDict objectForKey:@"lat"] floatValue], [[infoDict objectForKey:@"lng"] floatValue]);
                }
                if ([infoDict objectForKey:@"nearbyRadius"]) {
                    merchant.nearbyRadius = [infoDict objectForKey:@"nearbyRadius"];
                }
                if ([infoDict objectForKey:@"merchantRemarks"]) {
                    merchant.merchantSummary = [infoDict objectForKey:@"merchantRemarks"];
                }
                if ([infoDict objectForKey:@"merchantCategoryName"]) {
                    merchant.merchantCategoryName = [infoDict objectForKey:@"merchantCategoryName"];
                }
                if ([infoDict objectForKey:@"businessDistrictName"]) {
                    merchant.businessDistrictName = [infoDict objectForKey:@"businessDistrictName"];
                }
                if ([infoDict objectForKey:@"merchantTypeName"]) {
                    merchant.merchantTypeName = [infoDict objectForKey:@"merchantTypeName"];
                }
                [merchantArray addObject:merchant];
            }
            return merchantArray;
        }
        
        return nil;
    }];
    
    return result;
}

+ (Result *)requestOne:(NSNumber *)memberID merchantID:(NSNumber *)merchantID
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[memberID stringValue] forKey:@"memberId"];
    [params setObject:[merchantID stringValue] forKey:@"merchantId"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getMerchantDetail.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"detail"]) {
            Merchant *merchant = [[Merchant alloc] init];
            merchant.merchantID = merchantID;
            NSDictionary *infoDict = [responseObject objectForKey:@"detail"];
            if ([infoDict objectForKey:@"title"]) {
                merchant.merchantName = [infoDict objectForKey:@"title"];
            }
            if ([infoDict objectForKey:@"address"]) {
                merchant.address = [infoDict objectForKey:@"address"];
            }
            if ([infoDict objectForKey:@"traffic"]) {
                merchant.traffic = [infoDict objectForKey:@"traffic"];
            }
            if ([infoDict objectForKey:@"phone"]) {
                merchant.contact = [infoDict objectForKey:@"phone"];
            }
            if ([infoDict objectForKey:@"productCount"]) {
                merchant.productCount = [infoDict objectForKey:@"productCount"];
            }
            if ([infoDict objectForKey:@"storeCount"]) {
                merchant.storeCount = [infoDict objectForKey:@"storeCount"];
            }
            if ([infoDict objectForKey:@"isAttention"]) {
                merchant.hasCollect = [[infoDict objectForKey:@"isAttention"] boolValue];
            }
            if ([infoDict objectForKey:@"galleryList"]) {
                NSDictionary *galleryListDict = [infoDict objectForKey:@"galleryList"];
                NSMutableArray *merchantGalleryArray = [[NSMutableArray alloc] init];
                for (NSDictionary *galleryDict in galleryListDict) {
                    MerchantGallery *merchantGallery = [[MerchantGallery alloc] init];
                    if ([galleryDict objectForKey:@"id"]) {
                        merchantGallery.merchantGalleryID = [galleryDict objectForKey:@"id"];
                    }
                    if ([[UIScreen mainScreen] scale] == 2.0) {
                        merchantGallery.imageURLString = [galleryDict objectForKey:@"photo2x"];
                    } else {
                        merchantGallery.imageURLString = [galleryDict objectForKey:@"photo"];
                    }
                    if ([galleryDict objectForKey:@"title"]) {
                        merchantGallery.title = [galleryDict objectForKey:@"title"];
                    }
                    [merchantGalleryArray addObject:merchantGallery];
                }
                merchant.merchantGalleryArray = merchantGalleryArray;
            }
            if ([infoDict objectForKey:@"favourableList"]) {
                NSDictionary *discountListDict = [infoDict objectForKey:@"favourableList"];
                NSMutableArray *discountArray = [[NSMutableArray alloc] init];
                for (NSDictionary *discountDict in discountListDict) {
                    Discount *discount = [[Discount alloc] init];
                    if ([discountDict objectForKey:@"id"]) {
                        discount.discountID = [discountDict objectForKey:@"id"];
                    }
                    if ([discountDict objectForKey:@"title"]) {
                        discount.title = [discountDict objectForKey:@"title"];
                    }
                    if ([discountDict objectForKey:@"startTime"]) {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        dateFormatter.dateFormat = @"yyyy-MM-dd";
                        discount.startDate = [dateFormatter dateFromString:[discountDict objectForKey:@"startTime"]];
                    }
                    if ([discountDict objectForKey:@"endTime"]) {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        dateFormatter.dateFormat = @"yyyy-MM-dd";
                        discount.endDate = [dateFormatter dateFromString:[discountDict objectForKey:@"endTime"]];
                    }
                    [discountArray addObject:discount];
                }
                merchant.discountArray = discountArray;
            }
            return merchant;
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
        self.merchantID = [decoder decodeObjectForKey:@"merchantID"];
        self.imageURLString = [decoder decodeObjectForKey:@"imageURLString"];
        self.merchantName = [decoder decodeObjectForKey:@"merchantName"];
        self.storeID = [decoder decodeObjectForKey:@"storeID"];
        self.storeName = [decoder decodeObjectForKey:@"storeName"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.merchantID forKey:@"merchantID"];
    [encoder encodeObject:self.imageURLString forKey:@"imageURLString"];
    [encoder encodeObject:self.merchantName forKey:@"merchantName"];
    [encoder encodeObject:self.storeID forKey:@"storeID"];
    [encoder encodeObject:self.storeName forKey:@"storeName"];
}

@end
