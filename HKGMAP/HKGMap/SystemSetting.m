//
//  Setting.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-25.
//
//

#import "SystemSetting.h"
#import "WebAPI.h"

@implementation SystemSetting

+ (Result *)versionInformation
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getVersionUpdateUrl.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        SystemSetting *systemSetting = [[SystemSetting alloc] init];
        if ([responseObject objectForKey:@"version"]) {
            systemSetting.version = [responseObject objectForKey:@"version"];
        }
        if ([responseObject objectForKey:@"versionUpdateUrl"]) {
            systemSetting.updateVersionURLString = [responseObject objectForKey:@"versionUpdateUrl"];
        }

        return systemSetting;
    }];
    
    return result;
}

@end
