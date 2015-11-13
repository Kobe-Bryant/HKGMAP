//
//  MemberFindPasswordViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-28.
//
//

#import "MemberFindPasswordViewController.h"
#import "MemberFieldTableViewCell.h"
#import "Macros.h"
#import "NSString+Validator.h"
#import "Member.h"

@interface MemberFindPasswordViewController ()

@property (nonatomic, retain) UITextField *usernameTextField;
@property (nonatomic, retain) UIButton *resetButton;

@end

@implementation MemberFindPasswordViewController

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
    self.title = @"重置密码";
    
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
    
    
    self.usernameTextField = [[UITextField alloc] init];
    self.usernameTextField.font = [UIFont systemFontOfSize:15.0];
    self.usernameTextField.placeholder = @"请输入您的邮箱";
    self.usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.usernameTextField.delegate = self;
        
    UIImage *resetButtonImage = [UIImage imageNamed:@"MemberCellButton"];
    self.resetButton = [[UIButton alloc] init];
    self.resetButton.frame = CGRectMake(0.0, 0.0, 270.0, resetButtonImage.size.height);
    self.resetButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.resetButton setBackgroundImage:resetButtonImage forState:UIControlStateNormal];
    [self.resetButton setTitle:@"重置密码" forState:UIControlStateNormal];
    [self.resetButton addTarget:self
                         action:@selector(submit:)
               forControlEvents:UIControlEventTouchDown];
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

- (void)submit:(UIButton *)button
{
    NSString *loginUsername = self.usernameTextField.text;
    
    if ([loginUsername length] <= 0) {
        [self.usernameTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:self.usernameTextField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([loginUsername isEmail] == NO) {
        [self.usernameTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"邮箱格式不正确"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    [[UIApplication sharedApplication] resignFirstResponder];
    self.usernameTextField.enabled = NO;
    self.resetButton.enabled = NO;
    
    
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
        Result *result = [Member resetPassword:self.usernameTextField.text];
        if (result.isSuccess == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.usernameTextField.text = @"";
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"密码重置成功，请到您的邮箱查收相关邮件。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.usernameTextField.enabled = YES;
        self.resetButton.enabled = YES;
        [activityIndicatorView removeFromSuperview];
    });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        return 1.0;
    }
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0;
    } else if (section == 6) {
        return 0.0;
    }
    
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MemberFieldTableViewCell *cell = [[MemberFieldTableViewCell alloc] init];
        self.usernameTextField.frame = CGRectMake(9.0,
                                                  0.0,
                                                  252.0,
                                                  [self tableView:tableView heightForRowAtIndexPath:indexPath]);
        [cell.contentView addSubview:self.usernameTextField];
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        self.resetButton.frame = CGRectMake(25.0,
                                            0.0,
                                            self.resetButton.frame.size.width,
                                            self.resetButton.frame.size.height);
        [cell addSubview:self.resetButton];
        return cell;
    }
    
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        [self submit:nil];
    }
    
    return NO;
}


@end
