//
//  Member.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-18.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface Member : NSObject

@property (nonatomic, retain) NSNumber *memberID;
@property (nonatomic, retain) NSString *loginUsername;
@property (nonatomic, retain) NSString *loginPassword;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, readwrite) BOOL gender;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSString *birthday;

+ (Member *)sharedMember;
- (BOOL)isLogined;
- (Result *)toRegister;
- (Result *)login;
- (void)logout;
- (Result *)collectedMerchantCount;
- (Result *)collectedMerchantList:(NSInteger)offset limit:(NSInteger)limit;
- (Result *)collectedDiscountCount;
- (Result *)collectedDiscountList:(NSInteger)offset limit:(NSInteger)limit;
- (Result *)collectDiscount:(NSNumber *)discountID;
- (Result *)removeCollectDiscount:(NSNumber *)discountID;
- (Result *)collectMerchant:(NSNumber *)merchantID;
- (Result *)removeCollectMerchant:(NSNumber *)merchantID;
- (Result *)profile;
- (Result *)updateProfile;
- (Result *)updatePassword:(NSString *)oldPassword changePassword:(NSString *)changePassword;
+ (Result *)resetPassword:(NSString *)loginUsername;

@end
