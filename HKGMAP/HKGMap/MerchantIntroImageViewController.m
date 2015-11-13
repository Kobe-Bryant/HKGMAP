//
//  MerchantIntroImageViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import "MerchantIntroImageViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"

#define kImageWidth 320.0
#define kImageHeight 200.0

@interface MerchantIntroImageViewController ()

@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation MerchantIntroImageViewController

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
        self.merchantGallery = dataObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0.0, 0.0, kImageWidth, kImageHeight);
    imageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:imageView];
    
    if (self.merchantGallery.imageURLString != nil) {
        DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
        progressView.frame = CGRectMake((imageView.frame.size.width - 20.0) / 2.0,
                                        (imageView.frame.size.height - 20.0) / 2.0,
                                        20.0,
                                        20.0);
        progressView.progress = 0.0;
        [imageView addSubview:progressView];
        
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.merchantGallery.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished && error == nil) {
                imageView.image = image;
            }
            
            [progressView removeFromSuperview];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
