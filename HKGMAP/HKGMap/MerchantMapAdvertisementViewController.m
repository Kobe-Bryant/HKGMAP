//
//  MerchantMapAdvertisementViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-9.
//
//

#import "MerchantMapAdvertisementViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "ViewSize.h"
#import "Banner.h"

#define kImageHeight 50.0
#define kImageTag 4131

@interface MerchantMapAdvertisementViewController ()

@property (nonatomic, retain)NSArray *advertisementArray;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation MerchantMapAdvertisementViewController

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
        self.advertisementArray = dataObject;
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
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0.0,
                                 0.0,
                                 self.view.frame.size.width,
                                 kImageHeight);
    imageView.tag = kImageTag;
    imageView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tapBanner = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(tapBanner:)];
    tapBanner.numberOfTapsRequired = 1;
    tapBanner.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:tapBanner];
    [self.view addSubview:imageView];
    
    
    UIView *closeView = [[UIView alloc] init];
    closeView.frame = CGRectMake(self.view.frame.size.width - kImageHeight,
                                 0.0,
                                 kImageHeight,
                                 kImageHeight);
    closeView.hidden = YES;

    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(closeBanner:)];
    tapClose.numberOfTapsRequired = 1;
    tapClose.numberOfTouchesRequired = 1;
    [closeView addGestureRecognizer:tapClose];
    [self.view addSubview:closeView];

    UIImageView *closeImageView = [[UIImageView alloc] init];
    closeImageView.image = [UIImage imageNamed:@"MapCloseAdButton"];
    closeImageView.frame = CGRectMake(closeView.frame.size.width - closeImageView.image.size.width - 5.0,
                                      5.0,
                                      closeImageView.image.size.width,
                                      closeImageView.image.size.height);
    [closeView addSubview:closeImageView];
    
    if ([self.advertisementArray count] > 0) {
        Banner *banner = [self.advertisementArray objectAtIndex:0];
        if (banner.imageURLString != nil && banner.imageURLString.length > 0) {
            
            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:banner.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (finished && error == nil) {
                    imageView.image = image;
                    closeView.hidden = NO;
                }
            }];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)tapBanner:(UIGestureRecognizer *)gestureRecognizer
{
    Banner *banner = [self.advertisementArray objectAtIndex:0];
    if (banner.linkURLString != nil && banner.linkURLString.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:banner.linkURLString]];
    }
    
}

- (void)closeBanner:(UIGestureRecognizer *)gestureRecognizer
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.view.hidden = YES;
        }
    }];
}

@end
