//
//  MerchantTabBarViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-9.
//
//

#import "MerchantTabBarViewController.h"
#import "MerchantMapViewController.h"
#import "MerchantListViewController.h"
#import "MerchantFilterViewController.h"
#import "Macros.h"
#import "ViewSize.h"

@interface MerchantTabBarViewController ()

@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation MerchantTabBarViewController

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
    self.title = @"购物地图";
    
    
    // Navigation bar
    UIImage *listIcon = [UIImage imageNamed:@"NavigationBarListIcon"];
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0.0,
                                  0.0,
                                  listIcon.size.width,
                                  listIcon.size.height);
    [listButton setImage:listIcon forState:UIControlStateNormal];
    [listButton addTarget:self
                   action:@selector(switchTab:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *listButtonItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
    self.navigationItem.rightBarButtonItem = listButtonItem;
    
    
    // Hide tab bar
    self.tabBar.hidden = YES;
//    self.tabBar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 0.0);
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
    if (IOS_VERSION_LESS_THAN(@"7.0")) {
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]] == NO) {
                if (TARGETED_DEVICE_IS_IPHONE_568 == NO) {
                    [view setFrame:CGRectMake(view.frame.origin.x,
                                              view.frame.origin.y,
                                              view.frame.size.width,
                                              VIEW_HEIGHT - STATUS_BAR_HEIGHT - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
                }
            }
        }
    }
    

    
    
    
    MerchantMapViewController *mapVC = [[MerchantMapViewController alloc] init];
    MerchantListViewController *listVC = [[MerchantListViewController alloc] init];
    self.viewControllers = [[NSArray alloc] initWithObjects:mapVC, listVC, nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger currentIndex = [self.tabBar.items indexOfObject:item];
    if (currentIndex != self.selectedIndex)
    {
        // Get views. controllerIndex is passed in as the controller we want to go to.
        UIView *fromView = self.selectedViewController.view;
        UIView *toView = [[self.viewControllers objectAtIndex:currentIndex] view];
        
        // Transition using a page curl.
        UIViewAnimationOptions viewAnimationOption;
        if (currentIndex > self.selectedIndex) {
            viewAnimationOption = UIViewAnimationOptionTransitionFlipFromRight;
        } else {
            viewAnimationOption = UIViewAnimationOptionTransitionFlipFromLeft;
        }

        [UIView transitionFromView:fromView toView:toView duration:0.5 options:viewAnimationOption completion:
            ^(BOOL finished) {
                if (finished) {
                    self.selectedIndex = currentIndex;
                }
            }
         ];
    }
}

- (void)switchTab:(UIButton *)button
{
    NSUInteger selectedIndex = self.selectedIndex;
    NSUInteger targetIndex = selectedIndex == 0 ? 1 : 0;
    UIImage *buttonImage = [UIImage imageNamed:(targetIndex == 0 ? @"NavigationBarListIcon" : @"NavigationBarMapIcon")];
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, buttonImage.size.width, buttonImage.size.height);
    [button setImage:buttonImage forState:UIControlStateNormal];
    UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:targetIndex];
    [self tabBar:self.tabBar didSelectItem:tabBarItem];
}

@end
