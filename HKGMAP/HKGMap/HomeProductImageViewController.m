//
//  HomeProductImageViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-7.
//
//

#import "HomeProductImageViewController.h"
#import "ViewSize.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"
#import "Macros.h"

@interface HomeProductImageViewController ()

@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation HomeProductImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithBanner:(Banner *)banner
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.banner = banner;
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
    
    if (self.banner == nil) {
        return;
    }
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0.0,
                                 0.0,
                                 self.view.frame.size.width,
                                 self.view.frame.size.width);
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.userInteractionEnabled = YES;
    imageView.tag = self.banner.productID.integerValue;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(pressed:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:tap];
    
    if (self.banner.imageURLString != nil) {
        DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
        progressView.frame = CGRectMake((imageView.frame.size.width - 20.0) / 2.0,
                                        (imageView.frame.size.height - 20.0) / 2.0,
                                        20.0,
                                        20.0);
        progressView.progress = 0.0;
        [imageView addSubview:progressView];
        
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.banner.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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

- (void)pressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIImageView *imageView = (UIImageView *)tapGestureRecognizer.view;
    if (imageView.tag > 0) {
        [self.delegate didSelectProduct:[NSNumber numberWithInteger:imageView.tag]];
    }
}

@end
