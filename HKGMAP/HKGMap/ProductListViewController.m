//
//  ProductListViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import "ProductListViewController.h"
#import "ProductDetailViewController.h"
#import "ViewSize.h"
#import "Macros.h"
#import "Product.h"

//#define kBackgroundColor [UIColor colorWithRed:(242.0/255.0) green:(239.0/255.0) blue:(235.0/255.0) alpha:1.0]

@interface ProductListViewController ()

@property (nonatomic, retain) NSNumber *merchantID;
@property (nonatomic, retain) NSMutableArray *productArray;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation ProductListViewController

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
        self.merchantID = dataObject;
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
    
    
    // Background
    self.view.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
//    self.tabBarController.tabBar.hidden = YES;
    
    
    // Table
//    UITableView *tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0.0,
                                      0.0,
                                      self.view.frame.size.width,
                                      self.view.frame.size.height);
    self.tableView.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
    self.tableView.separatorColor = [UIColor clearColor];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    [self.view addSubview:tableView];
    
    
    
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
        Result *result = [Product requestList:self.merchantID offset:0 limit:100];
        if (result.isSuccess) {
            self.productArray = (NSMutableArray *)result.data;
            [self.tableView reloadData];
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (NSUInteger)ceil([self.productArray count] / 2.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListCell *cell = [[ProductListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    cell.delegate = self;

    if (indexPath.row * 2 < [self.productArray count]) {
        [cell setLeftProduct:[self.productArray objectAtIndex:(indexPath.row * 2)]];
        [cell setLeftProductIndex:(indexPath.row * 2)];
    } else {
        [cell setLeftProduct:nil];
    }
    if (indexPath.row * 2 + 1 < [self.productArray count]) {
        [cell setRightProduct:[self.productArray objectAtIndex:(indexPath.row * 2 + 1)]];
        [cell setRightProductIndex:(indexPath.row * 2 + 1)];
    } else {
        [cell setRightProduct:nil];
    }
    
    return cell;
}

#pragma mark - Product list view cell delegate
- (void)didSelectRowAtIndex:(NSUInteger)index
{
    Product *product = [self.productArray objectAtIndex:index];
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] initWithDataObject:product.productID];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)goBack:(UIButton *)button
{
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
}

@end
