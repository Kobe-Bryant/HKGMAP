//
//  MerchantIntroGalleryViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import "MerchantIntroGalleryViewController.h"
#import "MerchantIntroImageViewController.h"
#import "ViewSize.h"

#define kImageHeight 200.0

#define kPageControlHeight 40.0

@interface MerchantIntroGalleryViewController ()

@property (nonatomic, retain) NSArray *merchantGalleryArray;
@property (nonatomic, retain) UIPageViewController *pageViewController;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSArray *imageArray;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation MerchantIntroGalleryViewController

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
        self.merchantGalleryArray = dataObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    if ([self.merchantGalleryArray count] == 0) {
        return;
    }
    
    
    // Set page data source
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    
    // Load first image
    UIViewController *initialViewController = [self viewControllerAtIndex:0];
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:initialViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    if ([self.merchantGalleryArray count] == 0) {
        return;
    }
    
    // Page control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(self.view.frame.origin.x,
                                        kImageHeight - kPageControlHeight,
                                        self.view.frame.size.width,
                                        kPageControlHeight);
    
    UIImage *backgroundImage = [UIImage imageNamed:@"HomeShadow"];
    self.pageControl.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    if ([UIPageControl respondsToSelector:@selector(pageIndicatorTintColor)] == YES) {
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    }
    if ([UIPageControl respondsToSelector:@selector(currentPageIndicatorTintColor)] == YES) {
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = [self.imageArray count];
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
    MerchantIntroImageViewController *imageVC = (MerchantIntroImageViewController *)viewController;
    NSInteger currentIndex = [self.merchantGalleryArray indexOfObject:imageVC.merchantGallery];
    if (currentIndex + 1 >= [self.merchantGalleryArray count]) {
        currentIndex = 0;
    } else {
        currentIndex++;
    }
    return [self viewControllerAtIndex:currentIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    MerchantIntroImageViewController *imageVC = (MerchantIntroImageViewController *)viewController;
    NSInteger currentIndex = [self.merchantGalleryArray indexOfObject:imageVC.merchantGallery];
    if (currentIndex - 1 < 0) {
        currentIndex = [self.merchantGalleryArray count] - 1;
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
    MerchantGallery *merchantGallery = [self.merchantGalleryArray objectAtIndex:index];
    UIViewController *viewController = [[MerchantIntroImageViewController alloc] initWithDataObject:merchantGallery];
    return viewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        MerchantIntroImageViewController *currentVC = (MerchantIntroImageViewController *)[pageViewController.viewControllers lastObject];
        NSUInteger currentIndex = [self.merchantGalleryArray indexOfObject:currentVC.merchantGallery];
        self.pageControl.currentPage = currentIndex;
    }
}

@end
