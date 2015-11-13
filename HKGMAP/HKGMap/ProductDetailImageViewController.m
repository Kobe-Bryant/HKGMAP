//
//  ProductDetailImageViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import "ProductDetailImageViewController.h"
#import "Macros.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"
#import "ViewSize.h"

//#define kImageWidth 320.0
#define kImageHeight 400.0

@interface ProductDetailImageViewController ()

@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation ProductDetailImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDataObject:(ProductGallery *)productGallery
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        self.productGallery = productGallery;
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
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                        VIEW_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT);
    [self.view addSubview:scrollView];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0.0,
                                 0.0,
                                 self.view.frame.size.width,
                                 kImageHeight);
    imageView.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:imageView];
    
    
    if (self.productGallery.imageURLString != nil) {
        DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
        progressView.frame = CGRectMake((imageView.frame.size.width - 20.0) / 2.0,
                                        (imageView.frame.size.height - 20.0) / 2.0,
                                        20.0,
                                        20.0);
        progressView.progress = 0.0;
        [imageView addSubview:progressView];
        
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.productGallery.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished) {
                imageView.image = image;
                [progressView removeFromSuperview];
            }
        }];
    }
    
    
    
    //
    UILabel *snippetLabel = [[UILabel alloc] init];
    snippetLabel.frame = CGRectMake(13.0,
                                    CGRectGetMaxY(imageView.frame) + 30.0,
                                    self.view.frame.size.width - 26.0,
                                    100.0);
    snippetLabel.backgroundColor = [UIColor clearColor];
    snippetLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
    snippetLabel.font = [UIFont systemFontOfSize:13.0];
    snippetLabel.numberOfLines = 4;
    snippetLabel.text = self.productGallery.title;
    [snippetLabel sizeToFit];
    [scrollView addSubview:snippetLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
