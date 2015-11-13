//
//  InformationDetailMerchantListViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-24.
//
//

#import "InformationStoreListViewController.h"
#import "MerchantBranchMapViewController.h"
#import "InformationDetailViewController.h"
#import "Store.h"
#import "Discount.h"
#import "ViewSize.h"
#import "Macros.h"

@interface InformationStoreListViewController ()

@property (nonatomic, retain) NSNumber *discountID;
@property (nonatomic, retain) NSMutableArray *storeArray;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation InformationStoreListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
        self.discountID = dataObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Title
    self.title = @"参与此优惠商户";
    
    
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
    
    
    // Background color
//    self.view.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
    self.tableView.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
    self.tableView.separatorColor = [UIColor clearColor];
    
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
        Result *result = [Store requestList:@-1 discountID:self.discountID offset:0 limit:100];
        if (result.isSuccess) {
            self.storeArray = (NSMutableArray *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.storeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 185.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Store *store = [self.storeArray objectAtIndex:indexPath.row];
    
    MerchantBranchListViewCell *cell = [[MerchantBranchListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.delegate = self;
    [cell setTitle:store.name];
    [cell setAddress:[[NSString alloc] initWithFormat:@"地址：%@", store.address]];
    [cell setTraffic:[[NSString alloc] initWithFormat:@"交通：%@", store.traffic]];
    [cell setTelephone:[[NSString alloc] initWithFormat:@"电话：%@", store.contact]];
    [cell setDiscountArray:store.discountArray];
    [cell setSelectedIndex:indexPath.row];
    return cell;
}

#pragma mark - Branch list view cell delegate
- (void)didSelectRowAtIndex:(NSUInteger)index
{
    Store *store = [self.storeArray objectAtIndex:index];
    MerchantBranchMapViewController *mapVC = [[MerchantBranchMapViewController alloc] initWithDataObject:store];
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void)didSelectDiscount:(NSNumber *)discountID
{
    InformationDetailViewController *discountVC = [[InformationDetailViewController alloc] initWithDataObject:discountID];
    [self.navigationController pushViewController:discountVC animated:YES];
}


@end
