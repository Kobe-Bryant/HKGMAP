//
//  RootViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-3.
//
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "InformationListViewController.h"
#import "CalendarViewController.h"
#import "MerchantTabBarViewController.h"
#import "Macros.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Home
    UIViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UIImage *homeIcon = [UIImage imageNamed:@"TabBarHomeIcon"];
    UIImage *homeSelectedIcon = [UIImage imageNamed:@"TabBarHomeSelectedIcon"];
    
    if ([UIImage respondsToSelector:@selector(imageWithRenderingMode:)]) {
        UIImage *homeIconAlwaysOriginal = [homeIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *homeSelectedIconAlwaysOriginal = [homeSelectedIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                          image:homeIconAlwaysOriginal
                                                  selectedImage:homeSelectedIconAlwaysOriginal];
    } else {
        homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                          image:homeIcon
                                                            tag:0];
        [homeVC.tabBarItem setFinishedSelectedImage:homeSelectedIcon
                        withFinishedUnselectedImage:homeIcon];
    }
    
    
    // Information
    UIViewController *informationVC = [[InformationListViewController alloc] init];
    UINavigationController *informationNC = [[UINavigationController alloc] initWithRootViewController:informationVC];
    UIImage *informationIcon = [UIImage imageNamed:@"TabBarInformationIcon"];
    UIImage *informationSelectedIcon = [UIImage imageNamed:@"TabBarInformationSelectedIcon"];
    
    if ([informationIcon respondsToSelector:@selector(imageWithRenderingMode:)]) {
        UIImage *informationIconAlwaysOriginal = [informationIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *informationSelectedIconAlwaysOriginal = [informationSelectedIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        informationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"资讯"
                                                                 image:informationIconAlwaysOriginal
                                                         selectedImage:informationSelectedIconAlwaysOriginal];
    } else {
        informationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"资讯"
                                                                 image:informationIcon
                                                                   tag:0];
        [informationVC.tabBarItem setFinishedSelectedImage:informationSelectedIcon
                               withFinishedUnselectedImage:informationIcon];
    }
    
    
    
    // Calendar
    UIViewController *calendarVC = [[CalendarViewController alloc] init];
    calendarVC.title = @"活动日历";
    UINavigationController *calendarNC = [[UINavigationController alloc] initWithRootViewController:calendarVC];
    
    UIImage *calendarIcon = [UIImage imageNamed:@"TabBarCalendarIcon"];
    UIImage *calendarSelectedIcon = [UIImage imageNamed:@"TabBarCalendarSelectedIcon"];
    
    if ([calendarIcon respondsToSelector:@selector(imageWithRenderingMode:)]) {
        UIImage *calendarIconAlwaysOriginal = [calendarIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *calendarSelectedIconAlwaysOriginal = [calendarSelectedIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        calendarVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"日历"
                                                              image:calendarIconAlwaysOriginal
                                                      selectedImage:calendarSelectedIconAlwaysOriginal];
    } else {
        calendarVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"日历"
                                                              image:calendarIcon
                                                                tag:0];
        [calendarVC.tabBarItem setFinishedSelectedImage:calendarSelectedIcon
                            withFinishedUnselectedImage:calendarIcon];
    }
    
    
    // Map
    UIViewController *mapVC = [[MerchantTabBarViewController alloc] init];
    mapVC.title = @"购物地图";
    UINavigationController *mapNC = [[UINavigationController alloc] initWithRootViewController:mapVC];
    
    UIImage *mapIcon = [UIImage imageNamed:@"TabBarMapIcon"];
    UIImage *mapSelectedIcon = [UIImage imageNamed:@"TabBarMapSelectedIcon"];
    
    if ([mapIcon respondsToSelector:@selector(imageWithRenderingMode:)]) {
        UIImage *mapIconAlwaysOriginal = [mapIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *mapSelectedIconAlwaysOriginal = [mapSelectedIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"地图"
                                                         image:mapIconAlwaysOriginal
                                                 selectedImage:mapSelectedIconAlwaysOriginal];
    } else {
        mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"地图"
                                                         image:mapIcon
                                                           tag:0];
        [mapVC.tabBarItem setFinishedSelectedImage:mapSelectedIcon
                       withFinishedUnselectedImage:mapIcon];
    }
    
    
    // Medicine
    UIViewController *medicineVC = [[UIViewController alloc] init];
    UIImage *medicineIcon = [UIImage imageNamed:@"TabBarMedicineIcon"];
    UIImage *medicineSelectedIcon = [UIImage imageNamed:@"TabBarMedicineSelectedIcon"];
    
    if ([medicineIcon respondsToSelector:@selector(imageWithRenderingMode:)]) {
        UIImage *medicineIconAlwaysOriginal = [medicineIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *medicineSelectedIconAlwaysOriginal = [medicineSelectedIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        medicineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"医药"
                                                              image:medicineIconAlwaysOriginal
                                                      selectedImage:medicineSelectedIconAlwaysOriginal];
    } else {
        medicineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"医药"
                                                              image:medicineIcon
                                                                tag:0];
        [medicineVC.tabBarItem setFinishedSelectedImage:medicineSelectedIcon
                            withFinishedUnselectedImage:medicineIcon];
    }
    
    self.viewControllers = [[NSArray alloc] initWithObjects:homeNC, informationNC, calendarNC, mapNC, medicineVC, nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
