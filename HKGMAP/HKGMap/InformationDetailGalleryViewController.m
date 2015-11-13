//
//  InformationDetailGalleryViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-6.
//
//

#import "InformationDetailGalleryViewController.h"
#import "InformationDetailImageViewController.h"
#import "ViewSize.h"

#define kImageHeight 200.0

#define kPageControlHeight 40.0

@interface InformationDetailGalleryViewController ()

@property (nonatomic, retain) NSArray *discountGalleryArray;
@property (nonatomic, retain) UIPageViewController *pageViewController;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation InformationDetailGalleryViewController

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
        self.discountGalleryArray = dataObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([self.discountGalleryArray count] == 0) {
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
    if ([self.discountGalleryArray count] == 0) {
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
	self.pageControl.numberOfPages = [self.discountGalleryArray count];
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
    InformationDetailImageViewController *imageVC = (InformationDetailImageViewController *)viewController;
    NSInteger currentIndex = [self.discountGalleryArray indexOfObject:imageVC.discountGallery];
    if (currentIndex + 1 >= [self.discountGalleryArray count]) {
        currentIndex = 0;
    } else {
        currentIndex++;
    }
    return [self viewControllerAtIndex:currentIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    InformationDetailImageViewController *imageVC = (InformationDetailImageViewController *)viewController;
    NSInteger currentIndex = [self.discountGalleryArray indexOfObject:imageVC.discountGallery];
    if (currentIndex - 1 < 0) {
        currentIndex = [self.discountGalleryArray count] - 1;
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
    DiscountGallery *discountGallery = [self.discountGalleryArray objectAtIndex:index];
    UIViewController *viewController = [[InformationDetailImageViewController alloc] initWithDataObject:discountGallery];
    return viewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        InformationDetailImageViewController *currentVC = (InformationDetailImageViewController *)[pageViewController.viewControllers lastObject];
        NSUInteger currentIndex = [self.discountGalleryArray indexOfObject:currentVC.discountGallery];
        self.pageControl.currentPage = currentIndex;
    }
}

@end
