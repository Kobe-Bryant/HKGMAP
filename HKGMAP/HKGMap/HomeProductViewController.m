//
//  HomeProductViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-3.
//
//

#import "HomeProductViewController.h"
#import "ProductDetailViewController.h"
//#import "ProductDetailGalleryViewController.h"
#import "ViewSize.h"
//#import "CustomDefined.h"
#import "Banner.h"
#import "Macros.h"

@interface HomeProductViewController ()

@property (nonatomic, retain) UIPageViewController *pageViewController;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSArray *bannerArray;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation HomeProductViewController

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
        self.bannerArray = dataObject;
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
    if ([self.bannerArray count] == 0) {
        return;
    }
    
    // Scroll view
    // Set page data source
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0.0,
                                                    0.0,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.width);
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
//    self.pageViewController.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    
    // Load first image
    UIViewController *initialVC = [self viewControllerAtIndex:0];
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:initialVC]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];

    
    // Page control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(self.view.frame.origin.x,
                                        self.view.frame.size.height - 40.0,
                                        self.view.frame.size.width,
                                        40.0);
    
    UIImage *backgroundImage = [UIImage imageNamed:@"HomeShadow"];
    self.pageControl.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    if ([UIPageControl respondsToSelector:@selector(pageIndicatorTintColor)] == YES) {
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    }
    if ([UIPageControl respondsToSelector:@selector(currentPageIndicatorTintColor)] == YES) {
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = [self.bannerArray count];
    self.pageControl.userInteractionEnabled = NO;
	[self.view addSubview:self.pageControl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([self.bannerArray count] == 1) {
        return nil;
    }
    
    HomeProductImageViewController *imageVC = (HomeProductImageViewController *)viewController;
    imageVC.view.frame = CGRectMake(0.0,
                                    0.0,
                                    self.view.frame.size.width,
                                    self.view.frame.size.width);
    NSInteger currentIndex = [self.bannerArray indexOfObject:imageVC.banner];
    if (currentIndex + 1 >= [self.bannerArray count]) {
        currentIndex = 0;
    } else {
        currentIndex++;
    }
    return [self viewControllerAtIndex:currentIndex];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([self.bannerArray count] == 1) {
        return nil;
    }
    
    HomeProductImageViewController *imageVC = (HomeProductImageViewController *)viewController;
    NSInteger currentIndex = [self.bannerArray indexOfObject:imageVC.banner];
    if (currentIndex - 1 < 0) {
        currentIndex = [self.bannerArray count] - 1;
    } else {
        currentIndex--;
    }
    return [self viewControllerAtIndex:currentIndex];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    // The number of items reflected in the page indicator.
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    // The selected item reflected in the page indicator.
    return 0;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    Banner *banner = [self.bannerArray objectAtIndex:index];
    HomeProductImageViewController *viewController = [[HomeProductImageViewController alloc] initWithBanner:banner];
    viewController.delegate = self;
    return viewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        HomeProductImageViewController *currentVC = (HomeProductImageViewController *)[pageViewController.viewControllers lastObject];
        NSUInteger currentIndex = [self.bannerArray indexOfObject:currentVC.banner];
        self.pageControl.currentPage = currentIndex;
    }
}

- (void)didSelectProduct:(NSNumber *)productID
{
    ProductDetailViewController *galleryVC = [[ProductDetailViewController alloc] initWithDataObject:productID];
    galleryVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:galleryVC animated:YES];
}

@end
