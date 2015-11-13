//
//  Store.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-17.
//
//

#import "Store.h"
#import "WebAPI.h"

@implementation Store

+ (Result *)requestList:(NSNumber *)merchantID discountID:(NSNumber *)discountID offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[merchantID stringValue] forKey:@"merchantId"];
    [params setObject:[discountID stringValue] forKey:@"favourableId"];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];

    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getStoreList.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *storeArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Store *store = [[Store alloc] init];
                if ([infoDict objectForKey:@"id"]) {
                    store.storeID = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"name"]) {
                    store.name = [infoDict objectForKey:@"name"];
                }
                if ([infoDict objectForKey:@"address"]) {
                    store.address = [infoDict objectForKey:@"address"];
                }
                if ([infoDict objectForKey:@"traffic"]) {
                    store.traffic = [infoDict objectForKey:@"traffic"];
                }
                if ([infoDict objectForKey:@"phone"]) {
                    store.contact = [infoDict objectForKey:@"phone"];
                }
                if ([infoDict objectForKey:@"lat"] && [infoDict objectForKey:@"lng"]) {
                    store.coordinate = CLLocationCoordinate2DMake([[infoDict objectForKey:@"lat"] floatValue], [[infoDict objectForKey:@"lng"] floatValue]);
                }
                if ([infoDict objectForKey:@"favourableList"]) {
                    NSDictionary *discountListDict = [infoDict objectForKey:@"favourableList"];
                    NSMutableArray *discountArray = [[NSMutableArray alloc] init];
                    for (NSDictionary *discountInfoDict in discountListDict) {
                        Discount *discount = [[Discount alloc] init];
                        if ([discountInfoDict objectForKey:@"id"]) {
                            discount.discountID = [discountInfoDict objectForKey:@"id"];
                        }
                        if ([discountInfoDict objectForKey:@"title"]) {
                            discount.title = [discountInfoDict objectForKey:@"title"];
                        }
                        [discountArray addObject:discount];
                    }
                    store.discountArray = discountArray;
                }
                if ([infoDict objectForKey:@"phone"]) {
                    store.logoImageURLString = [infoDict objectForKey:@"phone"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    if ([infoDict objectForKey:@"photo2x"]) {
                        store.logoImageURLString = [infoDict objectForKey:@"photo2x"];
                    }
                } else {
                    if ([infoDict objectForKey:@"photo"]) {
                        store.logoImageURLString = [infoDict objectForKey:@"photo"];
                    }
                }
                [storeArray addObject:store];
            }
            return storeArray;
        }
        
        return nil;
    }];
    
    return result;
}

@end
