//
//  MerchantBranchMapViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-22.
//
//

#import "MerchantBranchMapViewController.h"
#import "Store.h"
#import "Macros.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "ViewSize.h"

@interface MerchantBranchMapViewController ()

@property (nonatomic, retain) GMSMapView *mapView;
@property (nonatomic, retain) Store *store;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation MerchantBranchMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDataObject:(id)dataObject
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.store = dataObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"位置";
    
    
    // Navigation bar
    UIImage *backIcon = [UIImage imageNamed:@"NavigationBarBackIcon"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0,
                                  0.0,
                                  backIcon.size.width,
                                  backIcon.size.height);
    [backButton setImage:backIcon forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    // Background
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
    
    
    self.mapView = [[GMSMapView alloc] init];
    self.mapView.frame = CGRectMake(0.0,
                                    0.0,
                                    self.view.frame.size.width,
                                    self.view.frame.size.height);
    self.mapView.camera = [GMSCameraPosition cameraWithLatitude:self.store.coordinate.latitude
                                                      longitude:self.store.coordinate.longitude
                                                           zoom:15];
    self.mapView.myLocationEnabled = YES;
    //    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = self.store.coordinate;
    marker.icon = [UIImage imageNamed:@"MapArrow"];
    marker.map = self.mapView;
    [self.mapView animateToLocation:self.store.coordinate];

    
    // Location
    UIImage *locationButtonImage = [UIImage imageNamed:@"MapLocationButton"];
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(10.0,
                                      self.view.frame.size.height - TAB_BAR_HEIGHT - 50.0 - locationButtonImage.size.height - 10.0,
                                      locationButtonImage.size.width,
                                      locationButtonImage.size.height);
    [locationButton setImage:locationButtonImage forState:UIControlStateNormal];
    [locationButton addTarget:self
                       action:@selector(backToMyLocation:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationButton];
    
    
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.store.logoImageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack:(UIButton *)button
{
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToMyLocation:(UIButton *)button
{
    [self.mapView animateToLocation:self.mapView.myLocation.coordinate];
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
@end
