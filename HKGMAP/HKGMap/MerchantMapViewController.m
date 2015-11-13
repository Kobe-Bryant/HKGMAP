//
//  MerchantMapViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-8.
//
//

#import "MerchantMapViewController.h"
#import "MerchantMapAdvertisementViewController.h"
#import "MerchantListViewController.h"
#import "MerchantIntroViewController.h"
#import "ViewSize.h"
#import "BusinessDistrict.h"
#import "MerchantType.h"
#import "Merchant.h"
#import "Banner.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Macros.h"

@interface MerchantMapViewController ()

@property (nonatomic, retain) MerchantFilterViewController *filterVC;
@property (nonatomic, retain) GMSMapView *mapView;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) CGFloat nearbyRadius;
@property (nonatomic, retain) NSNumber *businessDistrictID;
@property (nonatomic, retain) NSNumber *merchantTypeID;
@property (nonatomic, readwrite) NSInteger offset;
@property (nonatomic, retain) NSMutableArray *merchantArray;
@property (nonatomic, readwrite) BOOL isLoading;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation MerchantMapViewController

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

    
    // Map
    self.mapView = [[GMSMapView alloc] init];
    self.mapView.frame = CGRectMake(0.0,
                                    0.0,
                                    self.view.frame.size.width,
                                    self.view.frame.size.height);
    self.mapView.camera = [GMSCameraPosition cameraWithLatitude:22.396428
                                                      longitude:114.109497
                                                           zoom:10];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    

    
    // Location
    UIImage *locationButtonImage = [UIImage imageNamed:@"MapLocationButton"];
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(10.0,
                                      self.view.frame.size.height - 50.0 - locationButtonImage.size.height - 10.0,
                                      locationButtonImage.size.width,
                                      locationButtonImage.size.height);
    [locationButton setImage:locationButtonImage forState:UIControlStateNormal];
    [locationButton addTarget:self
                       action:@selector(backToMyLocation:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationButton];
    
    
    
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
           
            NSLog(@"%@",NSStringFromCGRect(self.filterVC.view.frame));
            
            
            self.filterVC.delegate = self;
            [self addChildViewController:self.filterVC];
            [self.view addSubview:self.filterVC.view];
        });
    });
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
        
        Result *result = [Merchant requestListAtMap:@"" currentCoordinate:self.coordinate nearbyRadius:0.0 businessDistrictID:self.businessDistrictID merchantTypeID:self.merchantTypeID offset:0 limit:1000];
        if (result.isSuccess) {
            self.merchantArray = (NSMutableArray *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                for (Merchant *merchant in self.merchantArray) {
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    marker.position = merchant.coordinate;
                    marker.icon = [UIImage imageNamed:@"MapArrow"];
                    marker.title = merchant.storeName;
                    marker.snippet = merchant.merchantSummary;
                    marker.map = self.mapView;
                    marker.userData = merchant.merchantID;
                    
                    if (merchant.imageURLString != nil
                        && merchant.imageURLString.length > 0) {
                        
                        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:merchant.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        } completed:^(UIImage *logoImage, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                            if (finished) {
                                if (error == nil && logoImage != nil) {
                                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
                                    dispatch_group_t group = dispatch_group_create();
                                    dispatch_group_async(group, queue, ^{
                                        UIImage *newImage = [self logoImageAddBackground:logoImage];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            marker.icon = newImage;
                                        });
                                    });
                                }
                            }
                        }];
                    }
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    });
    dispatch_group_async(group, queue, ^{
        // Advertisement
        Result *result = [Banner requestAdvertisementList:0 limit:5];
        if (result.isSuccess) {
            NSArray *advertisementArray = (NSArray *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                MerchantMapAdvertisementViewController *advertisementVC = [[MerchantMapAdvertisementViewController alloc] initWithDataObject:advertisementArray];
                advertisementVC.view.frame = CGRectMake(0.0,
                                                        self.view.frame.size.height - 50.0,
                                                        self.view.frame.size.width,
                                                        50.0);
                [self addChildViewController:advertisementVC];
                [self.view addSubview:advertisementVC.view];
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

- (void)backToMyLocation:(UIButton *)button
{
    [self.mapView animateToLocation:self.mapView.myLocation.coordinate];
}

- (void)reloadData
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
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        self.merchantArray = [[NSMutableArray alloc] init];
        
        Result *result = [Merchant requestListAtMap:@"" currentCoordinate:self.coordinate nearbyRadius:self.nearbyRadius businessDistrictID:self.businessDistrictID merchantTypeID:self.merchantTypeID offset:-1 limit:-1];
        if (result.isSuccess) {
            self.merchantArray = (NSMutableArray *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView clear];
                for (Merchant *merchant in self.merchantArray) {
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    marker.position = merchant.coordinate;
                    marker.title = merchant.storeName;
                    marker.snippet = merchant.merchantSummary;
                    marker.icon = [UIImage imageNamed:@"MapArrow"];
                    marker.map = self.mapView;
                    marker.userData = merchant.merchantID;
                    
                    if (merchant.imageURLString != nil) {
                        
                        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:merchant.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        } completed:^(UIImage *logoImage, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                            if (finished) {
                                if (error == nil && logoImage != nil) {
                                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
                                    dispatch_group_t group = dispatch_group_create();
                                    dispatch_group_async(group, queue, ^{
                                        UIImage *newImage = [self logoImageAddBackground:logoImage];
                                        UIGraphicsEndImageContext();
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            marker.icon = newImage;
                                        });
                                    });
                                }
                            }
                        }];
                    }
                }
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

- (UIImage *)logoImageAddBackground:(UIImage *)image2
{
    UIImage *image1 = [UIImage imageNamed:@"MapArrow"];
    CGSize size = CGSizeMake(image1.size.width, image1.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image1 drawInRect:CGRectMake(0.0, 0.0, image1.size.width, image1.size.height)];
    [image2 drawInRect:CGRectMake((image1.size.width - 40.0) / 2.0,
                                  3.0,
                                  40.0,
                                  40.0)];
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(),
                                     kCGInterpolationHigh);    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    [self.mapView animateToLocation:self.mapView.myLocation.coordinate];
    if (nearbyRadius == 100.0) {
        self.mapView.camera = [GMSCameraPosition cameraWithLatitude:self.mapView.myLocation.coordinate.latitude
                                                          longitude:self.mapView.myLocation.coordinate.longitude
                                                               zoom:19];
    } else if (nearbyRadius == 300.0) {
        self.mapView.camera = [GMSCameraPosition cameraWithLatitude:self.mapView.myLocation.coordinate.latitude
                                                          longitude:self.mapView.myLocation.coordinate.longitude
                                                               zoom:18];
    } else if (nearbyRadius == 500.0) {
        self.mapView.camera = [GMSCameraPosition cameraWithLatitude:self.mapView.myLocation.coordinate.latitude
                                                          longitude:self.mapView.myLocation.coordinate.longitude
                                                               zoom:17];
    } else if (nearbyRadius == 1000.0) {
        self.mapView.camera = [GMSCameraPosition cameraWithLatitude:self.mapView.myLocation.coordinate.latitude
                                                          longitude:self.mapView.myLocation.coordinate.longitude
                                                               zoom:16];
    } else if (nearbyRadius == 2000.0) {
        self.mapView.camera = [GMSCameraPosition cameraWithLatitude:self.mapView.myLocation.coordinate.latitude
                                                          longitude:self.mapView.myLocation.coordinate.longitude
                                                               zoom:15];
    }
    
    self.coordinate = self.mapView.myLocation.coordinate;
    self.nearbyRadius = nearbyRadius;
    self.offset = 0;
    [self reloadData];
}

- (void)didSelectBusinessDistrictID:(NSNumber *)businessDistrictID
{
    self.businessDistrictID = businessDistrictID;
    self.offset = 0;
    [self reloadData];
}

- (void)didSelectMerchantTypeID:(NSNumber *)merchantTypeID
{
    self.merchantTypeID = merchantTypeID;
    self.offset = 0;
    [self reloadData];
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    MerchantIntroViewController *introVC = [[MerchantIntroViewController alloc] initWithDataObject:marker.userData];
    introVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:introVC animated:YES];
}

@end
