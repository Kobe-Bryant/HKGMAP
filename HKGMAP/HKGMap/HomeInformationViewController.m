//
//  HomeInformationViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-3.
//
//

#import "HomeInformationViewController.h"
#import "InformationDetailViewController.h"
#import "ViewSize.h"
#import "DiscountCategory.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"
#import "CustomMarcos.h"

#define kImageWidth 140.0
#define kImageHeight 100.0

@interface HomeInformationViewController ()

@property (nonatomic, retain) NSArray *discountCategoryArray;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation HomeInformationViewController

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
        self.discountCategoryArray = dataObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
    CGFloat seperate = (self.view.frame.size.width - kImageWidth * 2.0) / 3.0;
    NSUInteger lineCount = floor(([self.discountCategoryArray count] + 1) / 2.0);
    if (lineCount < 2) {
        lineCount = 2;
    }
    CGFloat height = seperate * (lineCount + 1) + kImageHeight * lineCount;
    [self.delegate resetFrameHeight:self height:height];

    for (NSUInteger i = 0; i < [self.discountCategoryArray count]; i++) {
        DiscountCategory *discountCategory = [self.discountCategoryArray objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        NSUInteger row = floor(i / 2.0);
        CGFloat x = 0.0;
        if (i % 2 == 0) {
            x = seperate;
        } else {
            x = seperate * 2.0 + kImageWidth;
        }
        CGFloat y = seperate * (row + 1) + kImageHeight * row;
        
        imageView.frame = CGRectMake(x, y, kImageWidth, kImageHeight);
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 3.0;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        [self.view addSubview:imageView];
        
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tapGestureRecognizer];
        
        
        if (discountCategory.imageURLString != nil) {
            DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
            progressView.frame = CGRectMake((imageView.frame.size.width - 20.0) / 2.0,
                                            (imageView.frame.size.height - 20.0) / 2.0,
                                            20.0,
                                            20.0);
            progressView.progress = 0.0;
            [imageView addSubview:progressView];

            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:discountCategory.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (finished && error == nil) {
                    imageView.image = image;
                }
                
                [progressView removeFromSuperview];
            }];
        }
        
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.frame = CGRectMake(0.0,
                                          imageView.frame.size.height - 25.0,
                                          imageView.frame.size.width,
                                          25.0);
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.5;
        [imageView addSubview:backgroundView];
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(7.0,
                                      0.0,
                                      backgroundView.frame.size.width - 7.0 * 2.0,
                                      backgroundView.frame.size.height);
        titleLabel.font = [UIFont systemFontOfSize:13.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = discountCategory.title;
        [backgroundView addSubview:titleLabel];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    DiscountCategory *discountCategory = [self.discountCategoryArray objectAtIndex:tapGestureRecognizer.view.tag];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:discountCategory.discountCategoryID
                     forKey:DEFAULT_DISCOUNT_CATEGORY_ID];
    [userDefaults synchronize];
    
    self.tabBarController.selectedIndex = 1;
}

@end
