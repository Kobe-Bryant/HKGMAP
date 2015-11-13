//
//  MemberDiscountViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-21.
//
//

#import "MemberDiscountViewController.h"
#import "InformationListCell.h"
#import "InformationDetailViewController.h"
#import "ViewSize.h"
#import "Macros.h"
#import "DiscountCategory.h"
#import "Discount.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"
#import "Member.h"

@interface MemberDiscountViewController ()

@property (nonatomic, retain) NSMutableArray *discountArray;

@end

@implementation MemberDiscountViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    self.title = @"我的优惠";
    
    
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
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
        Result *result = [[Member sharedMember] collectedDiscountList:0 limit:100];
        if (result.isSuccess) {
            self.discountArray = (NSMutableArray *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.tableFooterView.hidden = YES;
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


@end
