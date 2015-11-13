//
//  MemberCenterViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-21.
//
//

#define LOGOUT_ALERT_VIEW_TAG 101

#import "MemberCenterViewController.h"
#import "MemberCenterTableViewCell.h"
//#import "MemberCenterButtonTableViewCell.h"
#import "MemberLoginViewController.h"
#import "MemberMerchantViewController.h"
#import "MemberDiscountViewController.h"
#import "MemberProfileViewController.h"
#import "MemberPasswordViewController.h"
#import "Macros.h"
#import "Member.h"
#import "CustomMarcos.h"
#import "AFHTTPRequestOperationManager.h"

@interface MemberCenterViewController ()

@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, readwrite) BOOL isTippedLogin;

@end

@implementation MemberCenterViewController

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
    self.title = @"会员中心";
    
    
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
    self.view.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
    self.tableView.separatorColor = [UIColor clearColor];
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"MemberCellButton"];
    self.saveButton = [[UIButton alloc] init];
    self.saveButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.saveButton addTarget:self
                        action:@selector(logout:)
              forControlEvents:UIControlEventTouchDown];
    
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeStatus:)
                                                 name:LOGIN_STATUS_CHANGE_NOTIFICATION
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[Member sharedMember] isLogined]) {
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isTippedLogin == NO && [[Member sharedMember] isLogined] == NO) {
        [self login];
    } else if ([[Member sharedMember] isLogined] == YES) {
        if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable && [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusUnknown) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, queue, ^{
                Result *result = [[Member sharedMember] login];
                if (result.isSuccess == NO) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self logout:nil];
                    });
                }
            });
        }
    }
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

- (void)login
{
    self.isTippedLogin = YES;
    MemberLoginViewController *loginVC = [[MemberLoginViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)logout:(UIButton *)button
{
    if ([[Member sharedMember] isLogined]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"确认要退出吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消", nil];
        alertView.tag = LOGOUT_ALERT_VIEW_TAG;
        [alertView show];
    } else {
        [self login];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[Member sharedMember] isLogined]) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            MemberMerchantViewController *merchantVC = [[MemberMerchantViewController alloc] init];
            [self.navigationController pushViewController:merchantVC animated:YES];
        } else if (indexPath.section == 0 && indexPath.row == 1) {
            MemberDiscountViewController *discountVC = [[MemberDiscountViewController alloc] init];
            [self.navigationController pushViewController:discountVC animated:YES];
        } else if (indexPath.section == 0 && indexPath.row == 2) {
            MemberProfileViewController *profileVC = [[MemberProfileViewController alloc] init];
            [self.navigationController pushViewController:profileVC animated:YES];
        } else if (indexPath.section == 0 && indexPath.row == 3) {
            MemberPasswordViewController *passwordVC = [[MemberPasswordViewController alloc] init];
            [self.navigationController pushViewController:passwordVC animated:YES];
        }
    } else {
        [self login];
    }    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section == 0) {
        MemberCenterTableViewCellStyle style;
        if (indexPath.row == 0) {
            style = MemberCenterTableViewFirstCell;
        } else if (indexPath.row == 3) {
            style = MemberCenterTableViewLastCell;
        } else {
            style = MemberCenterTableViewMinddleCell;
        }
        
        MemberCenterTableViewCell *cell = [[MemberCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault customCellStyle:style];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的关注";
            if ([[Member sharedMember] isLogined]) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_group_t group = dispatch_group_create();
                dispatch_group_async(group, queue, ^{
                    Result *result = [[Member sharedMember] collectedMerchantCount];
                    if (result.isSuccess) {
                        NSNumber *total = (NSNumber *)result.data;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.textLabel.text = [[NSString alloc] initWithFormat:@"我的关注 (%@)", total];
                        });
                    }
                });
            }
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"我的优惠";
            if ([[Member sharedMember] isLogined]) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_group_t group = dispatch_group_create();
                dispatch_group_async(group, queue, ^{
                    Result *result = [[Member sharedMember] collectedDiscountCount];
                    if (result.isSuccess) {
                        NSNumber *total = (NSNumber *)result.data;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.textLabel.text = [[NSString alloc] initWithFormat:@"我的优惠 (%@)", total];
                        });
                    }
                });
            }
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"账户信息";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"修改密码";
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        
        self.saveButton.frame = CGRectMake((tableView.frame.size.width - self.saveButton.frame.size.width) / 2.0,
                                           0.0,
                                           self.saveButton.frame.size.width,
                                           self.saveButton.frame.size.height);
        if ([[Member sharedMember] isLogined]) {
            [self.saveButton setTitle:@"退出" forState:UIControlStateNormal];
        } else {
            [self.saveButton setTitle:@"登录" forState:UIControlStateNormal];
        }
        

        
        [cell addSubview:self.saveButton];
        
        return cell;

    }
    
    return nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LOGOUT_ALERT_VIEW_TAG && buttonIndex == 0) {
        [[Member sharedMember] logout];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_STATUS_CHANGE_NOTIFICATION
                                                            object:self
                                                          userInfo:nil];
    }
}

// Notification
- (void)changeStatus:(NSNotification *)notification
{    
    [self.tableView reloadData];
}


@end
