//
//  InformationListViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-3.
//
//

#import "InformationListViewController.h"
#import "InformationListCell.h"
#import "InformationDetailViewController.h"
#import "ViewSize.h"
#import "Macros.h"
#import "CustomMarcos.h"
#import "DiscountCategory.h"
#import "Discount.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"

#define LIMIT 10

@interface InformationListViewController ()

@property (nonatomic, retain) NSNumber *discountCategoryId;
@property (nonatomic, readwrite) NSInteger offset;
@property (nonatomic, retain) NSArray *discountDategoryArray;
@property (nonatomic, retain) NSMutableArray *discountArray;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;
@property (nonatomic, readwrite) BOOL isLoading;
@property (nonatomic, retain) InformationListMenuView *menuView;

@end

@implementation InformationListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNumber *currentDiscountCategoryId = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_DISCOUNT_CATEGORY_ID];

    if (self.isViewWillAppeared) {
        if ([currentDiscountCategoryId isEqualToNumber:self.discountCategoryId]) {
            return;
        } else {
            self.discountCategoryId = currentDiscountCategoryId;
            self.discountArray = [[NSMutableArray alloc] init];
            [self.tableView reloadData];
        }
    } else {
        self.discountCategoryId = currentDiscountCategoryId;
        self.isViewWillAppeared = YES;
    }
    

    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableFooterView.frame = CGRectMake(0.0,
                                                      0.0,
                                                      self.tableView.frame.size.width,
                                                      self.tabBarController.tabBar.frame.size.height);
    self.tableView.tableFooterView.hidden = YES;
    UIActivityIndicatorView *tableFooterActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    tableFooterActivityIndicatorView.frame = self.tableView.tableFooterView.frame;
    [tableFooterActivityIndicatorView startAnimating];
    [self.tableView.tableFooterView addSubview:tableFooterActivityIndicatorView];
    
    
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
        if (self.menuView == nil) {
            Result *result = [DiscountCategory requestList:0 limit:10];
            if (result.isSuccess) {
                self.discountDategoryArray = result.data;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.menuView = [[InformationListMenuView alloc] initWithDataObject:self.discountDategoryArray];
                    self.menuView.frame = CGRectMake(0.0,
                                                     0.0,
                                                     self.view.frame.size.width,
                                                     self.navigationController.navigationBar.frame.size.height);
                    self.menuView.menuDelegate = self;
                    self.navigationItem.titleView = self.menuView;
                    [self.menuView tapDiscountCategory:self.discountCategoryId];                    
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.menuView tapDiscountCategory:self.discountCategoryId];
            });
        }
    });
    dispatch_group_async(group, queue, ^{
        self.offset = 0;
        self.discountArray = [[NSMutableArray alloc] init];
        [self appendRows];
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

- (void)appendRows
{
    if (self.isLoading == NO) {
        self.isLoading = YES;
        Result *result = [Discount requestList:nil endDate:nil dateFormatter:nil discountCategoryID:self.discountCategoryId offset:(self.offset == 0 ? 0 : self.offset + LIMIT) limit:LIMIT];
        if (result.isSuccess) {
            NSArray *discountArray = result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
                for (NSUInteger i = 0; i < [discountArray count]; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.discountArray count] + i) inSection:0];
                    [indexPathArray addObject:indexPath];
                }
                [self.tableView insertRowsAtIndexPaths:indexPathArray
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.discountArray addObjectsFromArray:discountArray];
                [self.tableView endUpdates];
                if ([discountArray count] > 0) {
                    self.offset += LIMIT;
                }
                
                self.tableView.tableFooterView.hidden = YES;
                self.isLoading = NO;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.tableFooterView.hidden = YES;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
                self.tableView.tableFooterView.hidden = YES;
                self.isLoading = NO;
            });
        }
    }
}

#pragma mark - InformationListMenuViewDelegate
- (void)switchDiscountCategoryIndex:(NSInteger)selectedIndex
{
    self.discountArray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
    
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
        if (selectedIndex == 0) {
            self.discountCategoryId = @-1;
        } else {
            DiscountCategory *discountCategory = [self.discountDategoryArray objectAtIndex:selectedIndex - 1];
            self.discountCategoryId = discountCategory.discountCategoryID;
        }
        self.offset = 0;
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.discountCategoryId
                         forKey:DEFAULT_DISCOUNT_CATEGORY_ID];
        [userDefaults synchronize];
        
        
        [self appendRows];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [activityIndicatorView removeFromSuperview];
    });
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
    return [self.discountArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.discountArray count] - 1) {
        return 230.0;
    } else {
        return 220.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationListCell *cell = [[InformationListCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                           reuseIdentifier:nil];
    
    Discount *discount = [self.discountArray objectAtIndex:indexPath.row];
    cell.imageView.backgroundColor = [UIColor lightGrayColor];
    [cell setImageURLString:discount.imageURLString];
    [cell setTitle:discount.title];
    [cell setDateString:[discount startEndDateString]];
    [cell setHasCoupon:discount.hasCoupon];
    [cell setHasDiscount:discount.hasDiscount];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    Discount *discount = [self.discountArray objectAtIndex:indexPath.row];
    InformationDetailViewController *detailVC = [[InformationDetailViewController alloc] initWithDataObject:discount.discountID];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height
        && self.tableView.tableFooterView.hidden == YES) {
        self.tableView.tableFooterView.hidden = NO;
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,
                                                self.tableView.contentSize.height + self.tableView.tableFooterView.frame.size.height);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            [self appendRows];
        });
    }
}

@end
