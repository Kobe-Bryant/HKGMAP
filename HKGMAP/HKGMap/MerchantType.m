//
//  MerchantType.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-17.
//
//

#import "MerchantType.h"
#import "WebAPI.h"

@implementation MerchantType

+ (Result *)requestList:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getMerchantTypeList.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {        
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *merchantTypeArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                MerchantType *merchantType = [[MerchantType alloc] init];
                if ([infoDict objectForKey:@"id"]) {
                    merchantType.merchantTypeID = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"name"]) {
                    merchantType.name = [infoDict objectForKey:@"name"];
                }
                [merchantTypeArray addObject:merchantType];
            }
            return merchantTypeArray;
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
        self.merchantTypeID = [decoder decodeObjectForKey:@"merchantTypeID"];
        self.name = [decoder decodeObjectForKey:@"name"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.merchantTypeID forKey:@"merchantTypeID"];
    [encoder encodeObject:self.name forKey:@"name"];
}

@end
