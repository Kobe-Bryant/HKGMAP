//
//  BusinessDistrict.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-17.
//
//

#import "BusinessDistrict.h"
#import "WebAPI.h"

@implementation BusinessDistrict

+ (Result *)requestList:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getBusinessDistrictList.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *businessDistrictArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                BusinessDistrict *businessDistrict = [[BusinessDistrict alloc] init];
                if ([infoDict objectForKey:@"id"]) {
                    businessDistrict.businessDistrictID = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"name"]) {
                    businessDistrict.name = [infoDict objectForKey:@"name"];
                }
                [businessDistrictArray addObject:businessDistrict];
            }
            return businessDistrictArray;
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
        self.businessDistrictID = [decoder decodeObjectForKey:@"businessDistrictID"];
        self.name = [decoder decodeObjectForKey:@"name"];
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.businessDistrictID forKey:@"businessDistrictID"];
    [encoder encodeObject:self.name forKey:@"name"];
}

@end
