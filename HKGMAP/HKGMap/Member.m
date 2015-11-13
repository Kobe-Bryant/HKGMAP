//
//  Member.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-18.
//
//

#import "Member.h"
#import "WebAPI.h"
#import "CustomMarcos.h"
#import "Merchant.h"

@implementation Member

static Member *sharedMemberManager = nil;

+ (Member *)sharedMember
{
    if (sharedMemberManager == nil) {
        sharedMemberManager = [[super allocWithZone:NULL] init];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        sharedMemberManager.memberID = [userDefaults objectForKey:MEMBER_ID];
        sharedMemberManager.loginUsername = [userDefaults objectForKey:LOGIN_USER_NAME];
        sharedMemberManager.loginPassword = [userDefaults objectForKey:LOGIN_PASSWORD];
    }
    
    return sharedMemberManager;
}

- (BOOL)isLogined
{
    return (sharedMemberManager.memberID != nil && sharedMemberManager.memberID > 0
            && sharedMemberManager.loginUsername != nil && [sharedMemberManager.loginUsername length] > 0
            && sharedMemberManager.loginPassword != nil && [sharedMemberManager.loginPassword length] > 0);
}

- (Result *)toRegister
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"register.html" params:params];
    Result *result = [webAPI post:nil];
    
    return result;
}

- (Result *)login
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"login.html" params:params];
    __block Result *result = [webAPI post:^id(id responseObject) {
        if ([responseObject objectForKey:@"detail"]) {
            NSDictionary *infoDict = [responseObject objectForKey:@"detail"];
            if ([infoDict objectForKey:@"id"]) {
                sharedMemberManager.memberID = [infoDict objectForKey:@"id"];
            }
        }
        
        sharedMemberManager.loginUsername = self.loginUsername;
        sharedMemberManager.loginPassword = self.loginPassword;
        [self saveDataToLocal];
        
        return result;
    }];
    
    return result;
}

- (void)logout
{
    sharedMemberManager.memberID = @-1;
    sharedMemberManager.loginUsername = @"";
    sharedMemberManager.loginPassword = @"";
    [self saveDataToLocal];
}

- (Result *)collectedMerchantCount
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[sharedMemberManager.memberID stringValue] forKey:@"memberId"];
    [params setObject:@"0" forKey:@"offset"];
    [params setObject:@"10" forKey:@"length"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getAttentionList.html" params:params];
    Result *result = [webAPI post:^id(id responseObject) {
        if ([responseObject objectForKey:@"total"]) {
            NSNumber *total = [responseObject objectForKey:@"total"];
            return total;
        }

        return @0;
    }];
    
    return result;
}

- (Result *)collectedMerchantList:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[sharedMemberManager.memberID stringValue] forKey:@"memberId"];
    [params setObject:[[[NSNumber alloc] initWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[[NSNumber alloc] initWithInteger:limit] stringValue] forKey:@"length"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getAttentionList.html" params:params];
    Result *result = [webAPI post:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *merchantArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Merchant *merchant = [[Merchant alloc] init];
                if ([infoDict objectForKey:@"id"]) {
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

- (Result *)collectedDiscountCount
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[sharedMemberManager.memberID stringValue] forKey:@"memberId"];
    [params setObject:@"0" forKey:@"offset"];
    [params setObject:@"10" forKey:@"length"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getCollectList.html" params:params];
    Result *result = [webAPI post:^id(id responseObject) {
        if ([responseObject objectForKey:@"total"]) {
            NSNumber *total = [responseObject objectForKey:@"total"];
            return total;
        }
        
        return @0;
    }];
    
    return result;
}

- (Result *)collectedDiscountList:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[sharedMemberManager.memberID stringValue] forKey:@"memberId"];
    [params setObject:[[[NSNumber alloc] initWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[[NSNumber alloc] initWithInteger:limit] stringValue] forKey:@"length"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getCollectList.html" params:params];
    Result *result = [webAPI post:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *discountArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Discount *discount = [[Discount alloc] init];
                if ([infoDict objectForKey:@"favourableId"]) {
                    discount.discountID = [infoDict objectForKey:@"favourableId"];
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

- (Result *)collectDiscount:(NSNumber *)discountID
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[sharedMemberManager.memberID stringValue] forKey:@"memberId"];
    [params setObject:[discountID stringValue] forKey:@"favourableId"];

    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"addCollect.html" params:params];
    Result *result = [webAPI post:nil];
    
    return result;
}

- (Result *)removeCollectDiscount:(NSNumber *)discountID
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[sharedMemberManager.memberID stringValue] forKey:@"memberId"];
    [params setObject:[discountID stringValue] forKey:@"favourableId"];

    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"removeCollect.html" params:params];
    Result *result = [webAPI post:nil];
    
    return result;
}

- (Result *)collectMerchant:(NSNumber *)merchantID
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[sharedMemberManager.memberID stringValue] forKey:@"memberId"];
    [params setObject:[merchantID stringValue] forKey:@"merchantId"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"addAttention.html" params:params];
    Result *result = [webAPI post:nil];
    
    return result;
}

- (Result *)removeCollectMerchant:(NSNumber *)merchantID
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[sharedMemberManager.memberID stringValue] forKey:@"memberId"];
    [params setObject:[merchantID stringValue] forKey:@"merchantId"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"removeAttention.html" params:params];
    Result *result = [webAPI post:nil];
    
    return result;
}

- (Result *)profile
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[sharedMemberManager.memberID stringValue] forKey:@"memberId"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getMemberInfo.html" params:params];
    Result *result = [webAPI post:^id(id responseObject) {
        if ([responseObject objectForKey:@"member"]) {
            Member *member = [[Member alloc] init];
            member.memberID = sharedMemberManager.memberID;
            member.loginUsername = sharedMemberManager.loginUsername;
            
            NSDictionary *infoDict = [responseObject objectForKey:@"member"];
            if ([infoDict objectForKey:@"name"]) {
                member.name = [infoDict objectForKey:@"name"];
            }
            if ([infoDict objectForKey:@"sex"]) {
                member.gender = [[infoDict objectForKey:@"sex"] boolValue];
            }
            if ([infoDict objectForKey:@"email"]) {
                member.email = [infoDict objectForKey:@"email"];
            }
            if ([infoDict objectForKey:@"mobile"]) {
                member.mobile = [infoDict objectForKey:@"mobile"];
            }
            if ([infoDict objectForKey:@"dateBirth"]) {
                member.birthday = [infoDict objectForKey:@"dateBirth"];
            }
            
            return member;
        }
        
        return nil;
    }];
    
    return result;
}

- (Result *)updateProfile
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[sharedMemberManager.memberID stringValue] forKey:@"memberId"];
    [params setObject:self.name forKey:@"name"];
    [params setObject:[[NSNumber numberWithBool:self.gender] stringValue] forKey:@"sex"];
    [params setObject:self.birthday forKey:@"dateBirth"];
    [params setObject:self.email forKey:@"email"];
    [params setObject:self.mobile forKey:@"mobile"];
     
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"updateMemberInfo.html" params:params];
    Result *result = [webAPI post:nil];

    return result;
}

- (Result *)updatePassword:(NSString *)oldPassword changePassword:(NSString *)changePassword
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[sharedMemberManager.memberID stringValue] forKey:@"memberId"];
    [params setObject:oldPassword forKey:@"orgPassword"];
    [params setObject:changePassword forKey:@"newPassword"];

    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"updatePassword.html" params:params];
    Result *result = [webAPI post:nil];
    if (result.isSuccess) {
        sharedMemberManager.loginPassword = changePassword;
        [self saveDataToLocal];
    }
    
    return result;
}

+ (Result *)resetPassword:(NSString *)loginUsername
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:loginUsername forKey:@"loginName"];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"resetPassword.html" params:params];
    __block Result *result = [webAPI post:^id(id responseObject) {
        NSLog(@"responseObject %@", responseObject);
        
        return result;
    }];
    
    return result;
}

- (void)saveDataToLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sharedMemberManager.memberID forKey:MEMBER_ID];
    [userDefaults setObject:sharedMemberManager.loginUsername forKey:LOGIN_USER_NAME];
    [userDefaults setObject:sharedMemberManager.loginPassword forKey:LOGIN_PASSWORD];
    [userDefaults synchronize];
}

@end
