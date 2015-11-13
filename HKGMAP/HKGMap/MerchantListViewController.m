//
//  MerchantListViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-9.
//
//

#import "MerchantListViewController.h"
#import "MerchantListCell.h"
#import "MerchantIntroViewController.h"
#import "ViewSize.h"
#import "Macros.h"
#import "BusinessDistrict.h"
#import "MerchantType.h"
#import "Merchant.h"

#define LIMIT 20

@interface MerchantListViewController ()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) MerchantFilterViewController *filterVC;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) CGFloat nearbyRadius;
@property (nonatomic, retain) NSNumber *businessDistrictID;
@property (nonatomic, retain) NSNumber *merchantTypeID;
@property (nonatomic, readwrite) NSInteger offset;
@property (nonatomic, retain) NSMutableArray *merchantArray;
@property (nonatomic, readwrite) BOOL isLoading;

@end

@implementation MerchantListViewController

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
    // Background color
    self.view.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
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
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                       self.view.frame.origin.y,
                                       self.view.frame.size.width,
                                       367.0)];
    }
    
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0.0,
                                      self.navigationController.navigationBar.frame.size.height,
                                      self.view.frame.size.width,
                                      self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.tableView.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableFooterView.frame = CGRectMake(0.0,
                                                      0.0,
                                                      self.tableView.frame.size.width,
                                                      self.tabBarController.tabBar.frame.size.height);
    self.tableView.tableFooterView.hidden = YES;

    UIActivityIndicatorView *tableFooterActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    tableFooterActivityIndicatorView.frame = self.tableView.tableFooterView.frame;
    [tableFooterActivityIndicatorView startAnimating];
    [self.tableView.tableFooterView addSubview:tableFooterActivityIndicatorView];

    
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
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        [locationManager startUpdatingLocation];
        
        self.coordinate = locationManager.location.coordinate;
        self.nearbyRadius = 0.0;
        self.businessDistrictID = @-1;
        self.merchantTypeID = @-1;
        self.offset = 0;
        
        self.merchantArray = [[NSMutableArray alloc] init];
        [self appendRows];
    });
    dispatch_group_async(group, queue, ^{
        // Filter
        Result *businessDistrictResult = [BusinessDistrict requestList:0 limit:100];
        Result *merchantTypeResult = [MerchantType requestList:0 limit:100];
        NSArray *businessDistrictArray = nil;
        NSArray *merchantTypeArray = nil;
        
        if (businessDistrictResult.isSuccess) {
            businessDistrictArray = businessDistrictResult.data;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[businessDistrictResult.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
        
        if (merchantTypeResult.isSuccess) {
            merchantTypeArray = merchantTypeResult.data;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[merchantTypeResult.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.filterVC = [[MerchantFilterViewController alloc] initWithDataObject:businessDistrictArray merchantTypeArray:merchantTypeArray];
            self.filterVC.view.frame = CGRectMake(0.0,
                                                  0.0,
                                                  self.view.frame.size.width,
                                                  self.navigationController.navigationBar.frame.size.height);
            self.filterVC.delegate = self;
            [self addChildViewController:self.filterVC];
            [self.view addSubview:self.filterVC.view];
        });
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [activityIndicatorView removeFromSuperview];
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appendRows
{
    if (self.isLoading == NO) {
        self.isLoading = YES;
        
        Result *result = [Merchant requestList:@"" currentCoordinate:self.coordinate nearbyRadius:self.nearbyRadius businessDistrictID:self.businessDistrictID merchantTypeID:self.merchantTypeID offset:self.offset limit:LIMIT];
        if (result.isSuccess) {
            NSMutableArray *merchantArray = (NSMutableArray *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
                for (NSUInteger i = 0; i < [merchantArray count]; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.merchantArray count] + i) inSection:0];
                    [indexPathArray addObject:indexPath];
                }
                [self.tableView insertRowsAtIndexPaths:indexPathArray
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.merchantArray addObjectsFromArray:merchantArray];
                [self.tableView endUpdates];
                if ([merchantArray count] > 0) {
                    self.offset += LIMIT;
                }
                
                self.tableView.tableFooterView.hidden = YES;
                self.isLoading = NO;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }

    }
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.merchantArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MerchantListCell *cell = [[MerchantListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    Merchant *merchant = [self.merchantArray objectAtIndex:indexPath.row];
    [cell setImageURLString:merchant.imageURLString];
    [cell setTitle:merchant.merchantName];
    [cell setSnippet:merchant.merchantSummary];
    [cell setCategory:[[NSString alloc] initWithFormat:@"%@   %@   %@", merchant.merchantCategoryName, merchant.businessDistrictName, merchant.merchantTypeName]];
    [cell setDistance:merchant.nearbyRadius];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Merchant *merchant = [self.merchantArray objectAtIndex:indexPath.row];
    MerchantIntroViewController *introVC = [[MerchantIntroViewController alloc] initWithDataObject:merchant.merchantID];
    introVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:introVC animated:YES];
}

#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height
        && self.tableView.tableFooterView.hidden == YES) {
        self.tableView.tableFooterView.hidden = NO;
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,
                                                self.tableView.contentSize.height + self.tableView.tableFooterView.frame.size.height);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            [self appendRows];
        });
    }
}

#pragma mark - MerchantFilterViewControllerDelegate
- (void)showFilterSubmenu
{
    self.filterVC.view.frame = CGRectMake(0.0,
                                          0.0,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height);
}

- (void)hideFilterSubmenu
{
    self.filterVC.view.frame = CGRectMake(0.0,
                                          0.0,
                                          self.view.frame.size.width,
                                          NAVIGATION_BAR_HEIGHT);
}

- (void)didSelectNearbyRadius:(CGFloat)nearbyRadius
{
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
    
    
    self.merchantArray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];

    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        self.nearbyRadius = nearbyRadius;
        self.offset = 0;
        
        self.merchantArray = [[NSMutableArray alloc] init];
        [self appendRows];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.contentOffset = CGPointZero;
        });
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [activityIndicatorView removeFromSuperview];
    });
}

- (void)didSelectBusinessDistrictID:(NSNumber *)businessDistrictID
{
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
    
    
    self.merchantArray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        self.businessDistrictID = businessDistrictID;
        self.offset = 0;
        
        self.merchantArray = [[NSMutableArray alloc] init];
        [self appendRows];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.contentOffset = CGPointZero;
        });
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [activityIndicatorView removeFromSuperview];
    });
}


- (void)didSelectMerchantTypeID:(NSNumber *)merchantTypeID
{
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
    
    
    self.merchantArray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];

    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        self.merchantTypeID = merchantTypeID;
        self.offset = 0;
        
        self.merchantArray = [[NSMutableArray alloc] init];
        [self appendRows];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.contentOffset = CGPointZero;
        });
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [activityIndicatorView removeFromSuperview];
    });
}



@end
