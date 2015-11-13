//
//  MemberMerchantViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-21.
//
//

#import "MemberMerchantViewController.h"
#import "MerchantIntroViewController.h"
#import "Macros.h"
#import "Member.h"
#import "Merchant.h"

//#define LIMIT 100

@interface MemberMerchantViewController ()

@property (nonatomic, readwrite) NSInteger offset;
@property (nonatomic, retain) NSArray *merchantArray;

@end

@implementation MemberMerchantViewController

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
    self.title = @"我的关注";
    
    
    
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
        self.offset = 0;
        Result *result = [[Member sharedMember] collectedMerchantList:self.offset limit:100];
        if (result.isSuccess) {
            self.merchantArray = (NSArray *)result.data;
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
    return [self.merchantArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Merchant *merchant = [self.merchantArray objectAtIndex:indexPath.row];

    MemberMerchantTableViewCell *cell = [[MemberMerchantTableViewCell alloc] init];
    [cell setIndexPath:indexPath];
    [cell setMerchantID:merchant.merchantID];
    [cell setImageURLString:merchant.imageURLString];
    [cell setTitle:merchant.merchantName];
    [cell setSnippet:merchant.merchantSummary];
    [cell setCategory:[[NSString alloc] initWithFormat:@"%@   %@   %@", merchant.merchantCategoryName, merchant.businessDistrictName, merchant.merchantTypeName]];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Merchant *merchant = [self.merchantArray objectAtIndex:indexPath.row];
    MerchantIntroViewController *introVC = [[MerchantIntroViewController alloc] initWithDataObject:merchant.merchantID];
    introVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:introVC animated:YES];
}

#pragma mark - MemberMerchantTableViewCellDelegate
- (void)didSelectCancelButton:(NSNumber *)merchantID indexPath:(NSIndexPath *)indexPath
{    
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
        Result *cancelResult = [[Member sharedMember] removeCollectMerchant:merchantID];
        if (cancelResult.isSuccess) {
            self.offset = 0;
            Result *listResult = [[Member sharedMember] collectedMerchantList:self.offset limit:100];
            if (listResult.isSuccess) {
                self.merchantArray = (NSArray *)listResult.data;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[listResult.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[cancelResult.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [activityIndicatorView removeFromSuperview];
    });

}

@end
