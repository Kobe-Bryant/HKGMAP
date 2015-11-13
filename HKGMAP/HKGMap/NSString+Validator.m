//
//  NSString+Validator.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-18.
//
//

#import "NSString+Validator.h"

@implementation NSString(Validator)

- (BOOL)isEmail
{
    NSString *regex = @"^[a-zA-Z0-9!#$%&\'*+\\/=?^_`{|}~-]+(?:.[a-zA-Z0-9!#$%&\'*+\\/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)isMobile
{
    NSString *regex = @"^(13|14|15|17|18)[0-9]{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

@end
