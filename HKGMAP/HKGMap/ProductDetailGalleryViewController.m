//
//  ProductDetailGalleryViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import "ProductDetailGalleryViewController.h"
#import "ProductDetailImageViewController.h"
#import "ViewSize.h"
#import "Macros.h"
#import "ProductGallery.h"

#define kImageHeight 400.0

#define kPageControlHeight 25.0

@interface ProductDetailGalleryViewController ()

//@property (nonatomic, retain) NSNumber *productID;
@property (nonatomic, retain) NSArray *productGalleryArray;
@property (nonatomic, retain) UIPageViewController *pageViewController;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation ProductDetailGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDataObject:(id)dataObject;
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.productGalleryArray = dataObject;
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
    
    
    if ([self.productGalleryArray count] == 0) {
        return;
    }

   
    
    // Set page data source
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
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
    
    
    if ([self.productGalleryArray count] == 0) {
        return;
    }
    
    
    
    // Page control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(self.view.frame.origin.x,
                                        kImageHeight,
                                        self.view.frame.size.width,
                                        kPageControlHeight);
    
    if ([UIPageControl respondsToSelector:@selector(pageIndicatorTintColor)]) {
        self.pageControl.pageIndicatorTintColor = UIColorFromRGB(211.0, 211.0, 211.0);
    }
    if ([UIPageControl respondsToSelector:@selector(currentPageIndicatorTintColor)]) {
        self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    }
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.productGalleryArray count];
    self.pageControl.userInteractionEnabled = NO;
    [self.view addSubview:self.pageControl];

    
    
    
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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    ProductDetailImageViewController *imageVC = (ProductDetailImageViewController *)viewController;
    NSInteger currentIndex = [self.productGalleryArray indexOfObject:imageVC.productGallery];
    if (currentIndex + 1 >= [self.productGalleryArray count]) {
        currentIndex = 0;
    } else {
        currentIndex++;
    }
    return [self viewControllerAtIndex:currentIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    ProductDetailImageViewController *imageVC = (ProductDetailImageViewController *)viewController;
    NSInteger currentIndex = [self.productGalleryArray indexOfObject:imageVC.productGallery];
    if (currentIndex - 1 < 0) {
        currentIndex = [self.productGalleryArray count] - 1;
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
    ProductGallery *productGallery = [self.productGalleryArray objectAtIndex:index];
    UIViewController *viewController = [[ProductDetailImageViewController alloc] initWithDataObject:productGallery];
    return viewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        ProductDetailImageViewController *currentVC = (ProductDetailImageViewController *)[pageViewController.viewControllers lastObject];
        NSUInteger currentIndex = [self.productGalleryArray indexOfObject:currentVC.productGallery];
        self.pageControl.currentPage = currentIndex;
    }
}

@end