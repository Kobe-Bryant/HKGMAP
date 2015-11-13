//
//  AppDelegate.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-2.
//
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AFHTTPRequestOperationManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Macros.h"
#import "AFHTTPRequestOperationManager.h"
#import "SubscribeDevice.h"
#import "UIDevice-Hardware.h"
#import "CustomMarcos.h"
#import "Member.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Google map api key
    [GMSServices provideAPIKey:@"AIzaSyD5kjDNqhY2HzohmZ5L9f8a7hMVYDJjdp8"];
    
    
    // Create a 4MB in-memory, 32MB disk cache
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                      diskCapacity:64 * 1024 * 1024
                                                          diskPath:@"URLCache"];
    
    // Set the shared cache to our new instance
    [NSURLCache setSharedURLCache:cache];

    
    
    // User defaults
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                              [[NSString alloc] init], DEVICE_TOKEN,
                              [NSNumber numberWithBool:NO], IS_AUTO_DOWNLOAD_ON_WWAN,
                              [NSNumber numberWithBool:NO], IS_DISPLAY_IMAGE_ON_WWAN,
                              [NSNumber numberWithBool:YES], ENABLED_ROMOTE_NOTIFICATION,
                              @-1, MEMBER_ID,
                              [[NSString alloc] init], LOGIN_USER_NAME,
                              [[NSString alloc] init], LOGIN_PASSWORD,
                              @-1, DEFAULT_DISCOUNT_CATEGORY_ID,
                              nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    [[NSUserDefaults standardUserDefaults] setValue:@-1 forKey:DEFAULT_DISCOUNT_CATEGORY_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    

    
    // Reachability
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    // Let the device know we want to receive push notifications
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];


    // Set status bar style
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
    // Set navigation bar style
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"Transparent"]];
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(245.0, 101.0,77.0), NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    
    // Set tab bar style
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"TabBarBackground"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"TabBarSelectionIndicator"]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(85.0, 85.0, 85.0), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(156.0, 156.0, 156.0), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    // Set search bar style
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"SearchBarBackground"] forState:UIControlStateNormal];
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"]];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"SearchBarSearchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"SearchBarClearIcon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"SearchBarClearSelectedIcon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    [[UISearchBar appearance] setTintColor:UIColorFromRGB(122.0, 41.0, 36.0)];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    RootViewController *rootViewController = [[RootViewController alloc] init];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *_deviceTokenString = [deviceToken description];
    if (_deviceTokenString != nil && _deviceTokenString.length > 0) {
        _deviceTokenString = [_deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
        _deviceTokenString = [_deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
        _deviceTokenString = [_deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_deviceTokenString forKey:DEVICE_TOKEN];
        [userDefaults synchronize];
        
        if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable || [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusUnknown) {
            SubscribeDevice *subscribeDevice = [[SubscribeDevice alloc] init];
            subscribeDevice.deviceToken = _deviceTokenString;
            subscribeDevice.isSubscribe = [userDefaults boolForKey:ENABLED_ROMOTE_NOTIFICATION];

            dispatch_queue_t queue = dispatch_queue_create("com.doocom.SyncDeviceToken", NULL);
            dispatch_async(queue, ^{
                [subscribeDevice sync];
            });
        }
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HKGMap" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HKGMap.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
