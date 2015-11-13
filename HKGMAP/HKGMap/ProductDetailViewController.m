//
//  ProductDetailViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import "ProductDetailViewController.h"
#import "ProductDetailGalleryViewController.h"
#import "ViewSize.h"
#import "Macros.h"
#import "ProductGallery.h"

//#define kBackgroundColor [UIColor colorWithRed:(242.0/255.0) green:(239.0/255.0) blue:(235.0/255.0) alpha:1.0]

#define kGalleryWidth 320.0
#define kGalleryHeight 425.0

//#define kFontColor [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0]

@interface ProductDetailViewController ()

@property (nonatomic, retain) NSNumber *productID;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation ProductDetailViewController

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
        self.productID = dataObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"新品";
    

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
    
    
    self.view.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
//    [UIColor colorWithRed:(242.0/255.0) green:(239.0/255.0) blue:(235.0/255.0) alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
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
        Result *result = [ProductGallery requestList:self.productID offset:-1 limit:-1];
        if (result.isSuccess) {
            NSArray *productGalleryArray = result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                // Gallery
                ProductDetailGalleryViewController *galleryVC = [[ProductDetailGalleryViewController alloc] initWithDataObject:productGalleryArray];
                galleryVC.view.frame = CGRectMake(0.0,
                                                  0.0,
                                                  self.view.frame.size.width,
                                                  self.view.frame.size.height);
                [self addChildViewController:galleryVC];
                [self.view addSubview:galleryVC.view];
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

- (void)goBack:(UIButton *)button
{
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
}


@end
