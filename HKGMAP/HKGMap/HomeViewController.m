//
//  HomeViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-3.
//
//

#import "HomeViewController.h"
#import "HomeProductViewController.h"
#import "SettingViewController.h"
#import "MemberCenterViewController.h"
#import "MerchantIntroViewController.h"
#import <MapKit/MapKit.h>
#import "Macros.h"
#import "Banner.h"
#import "DiscountCategory.h"
#import "Merchant.h"
#import "AFNetworkReachabilityManager.h"


@interface HomeViewController ()

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UIView *resultMaskView;
@property (nonatomic, retain) UITableView *resultTableView;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;
@property (nonatomic, retain) NSMutableArray *searchMerchantArray;

@end

@implementation HomeViewController

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
    // Navigation bar
    [self addNavigationItems];
    
    
    NSLog(@"%ld",[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus);
    
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.frame = CGRectMake(0.0, 0.0, 200.0, 30.0);
    self.searchBar.delegate = self;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"搜索" attributes:[NSDictionary dictionaryWithObject:UIColorFromRGB(229.0, 77.0, 69.0) forKey:NSForegroundColorAttributeName]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedString];
    self.navigationItem.titleView = self.searchBar;
    
    
    // Background color
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // Default data
    self.searchMerchantArray = [[NSMutableArray alloc] init];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }

    
    // Scroll view
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0.0,
                                       0.0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100.0) / 2.0,
                                             (self.view.frame.size.height - 100.0) / 2.0,
                                             100.0,
                                             100.0);
    activityIndicatorView.backgroundColor = [UIColor blackColor];
    activityIndicatorView.layer.cornerRadius = 10.0;
    activityIndicatorView.alpha = 0.7;
    [activityIndicatorView startAnimating];
    [self.view addSubview:activityIndicatorView];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        Result *result = [Banner requestBannerList:0 limit:5];
        if (result.isSuccess) {
            NSArray *bannerArray = (NSArray *)result.data;
            
            NSLog(@"%d",bannerArray.count);
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                HomeProductViewController *productVC = [[HomeProductViewController alloc] initWithDataObject:bannerArray];
                productVC.view.frame = CGRectMake(0.0,
                                                  0.0,
                                                  self.view.frame.size.width,
                                                  self.view.frame.size.width);
                [self addChildViewController:productVC];
                [self.scrollView addSubview:productVC.view];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    });
    dispatch_group_async(group, queue, ^{
        Result *result = [DiscountCategory requestList:0 limit:4];
        if (result.isSuccess) {
            NSMutableArray *discountCategoryArray = (NSMutableArray *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                HomeInformationViewController *informationVC = [[HomeInformationViewController alloc] initWithDataObject:discountCategoryArray];
                informationVC.view.frame = CGRectMake(0.0,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.height - self.view.frame.size.width);
                informationVC.delegate = self;
                [self addChildViewController:informationVC];
                [self.scrollView addSubview:informationVC.view];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [activityIndicatorView removeFromSuperview];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNavigationItems
{
    UIImage *settingIcon = [UIImage imageNamed:@"NavigationBarSettingIcon"];
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(0.0,
                                     0.0,
                                     settingIcon.size.width,
                                     settingIcon.size.height);
    [settingButton setImage:settingIcon forState:UIControlStateNormal];
    [settingButton addTarget:self
                      action:@selector(goToSetting:)
            forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.leftBarButtonItem = settingButtonItem;
    
    
    UIImage *memberIcon = [UIImage imageNamed:@"NavigationBarMemberIcon"];
    UIButton *memberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    memberButton.frame = CGRectMake(0.0,
                                    0.0,
                                    memberIcon.size.width,
                                    memberIcon.size.height);
    [memberButton setImage:memberIcon forState:UIControlStateNormal];
    [memberButton addTarget:self
                     action:@selector(goToMemberCenter:)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *memberButtonItem = [[UIBarButtonItem alloc] initWithCustomView:memberButton];
    self.navigationItem.rightBarButtonItem = memberButtonItem;
}

- (void)goToSetting:(UIButton *)button
{
    // Tell the controller to go back
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
//    [self.navigationController presentViewController:settingVC animated:YES completion:^{
//    }];
}

- (void)goToMemberCenter:(UIButton *)button
{
    // Tell the controller to go back
    MemberCenterViewController *memberCenterVC = [[MemberCenterViewController alloc] init];
    memberCenterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:memberCenterVC animated:YES];
}

- (void)restore
{
    self.tabBarController.tabBar.hidden = NO;
    if (self.resultTableView != nil) {
        [self.resultTableView removeFromSuperview];
        self.resultTableView = nil;
    }
    
    [self.resultMaskView removeFromSuperview];
    self.resultMaskView = nil;
    
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
    [self addNavigationItems];
}

#pragma mark - HomeInformationViewControllerDelegate
- (void)resetFrameHeight:(UIViewController *)currentController height:(CGFloat)height
{
    currentController.view.frame = CGRectMake(currentController.view.frame.origin.x,
                                              currentController.view.frame.origin.y,
                                              currentController.view.frame.size.width,
                                              height);
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                             CGRectGetMaxY(currentController.view.frame));
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    [self.searchBar resignFirstResponder];
    self.resultTableView.frame = CGRectMake(0.0,
                                            0.0,
                                            self.view.frame.size.width,
                                            self.view.frame.size.height + self.tabBarController.tabBar.frame.size.height);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchMerchantArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    Merchant *merchant = [self.searchMerchantArray objectAtIndex:indexPath.row];
    cell.textLabel.text = merchant.merchantName;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Merchant *merchant = [self.searchMerchantArray objectAtIndex:indexPath.row];
    MerchantIntroViewController *introVC = [[MerchantIntroViewController alloc] initWithDataObject:merchant.merchantID];
    introVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:introVC animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] > 0) {
        if (self.resultTableView == nil) {
            self.tabBarController.tabBar.hidden = YES;
            
            self.resultTableView = [[UITableView alloc] init];
            self.resultTableView.frame = CGRectMake(0.0,
                                                    0.0,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height);
            self.resultTableView.delegate = self;
            self.resultTableView.dataSource = self;
            [self.view addSubview:self.resultTableView];
        }
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            Result *result = [Merchant requestList:searchText currentCoordinate:CLLocationCoordinate2DMake(0.0, 0.0) nearbyRadius:0.0 businessDistrictID:@-1 merchantTypeID:@-1 offset:0 limit:100];
            if (result.isSuccess) {
                self.searchMerchantArray = (NSMutableArray *)result.data;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.resultTableView reloadData];
                });
            }
        });
    } else {
        [self.resultTableView removeFromSuperview];
        self.resultTableView = nil;
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    searchBar.showsCancelButton = YES;
    
    if (self.resultMaskView == nil) {
        self.resultMaskView = [[UIView alloc] init];
        self.resultMaskView.frame = CGRectMake(0.0,
                                               0.0,
                                               self.view.frame.size.width,
                                               self.view.frame.size.height);
        self.resultMaskView.backgroundColor = [UIColor clearColor];
        
        HomeResultMaskGestureRecognizer *gestureRecognizer = [[HomeResultMaskGestureRecognizer alloc] init];
        gestureRecognizer._delegate = self;
        [self.resultMaskView addGestureRecognizer:gestureRecognizer];
        
        [self.view addSubview:self.resultMaskView];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self restore];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        Result *result = [Merchant requestList:searchBar.text currentCoordinate:CLLocationCoordinate2DMake(0.0, 0.0) nearbyRadius:0.0 businessDistrictID:@-1 merchantTypeID:@-1 offset:0 limit:100];
        if (result.isSuccess) {
            self.searchMerchantArray = (NSMutableArray *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.resultTableView reloadData];
            });
        }
    });
}

#pragma mark - HomeResultMaskGestureRecognizerDelegate
- (void)homeResultMaskEnded
{
    [self restore];
}

@end
