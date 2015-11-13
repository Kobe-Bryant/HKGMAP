//
//  MemberPasswordViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-24.
//
//

#import "MemberPasswordViewController.h"
#import "MemberFieldTableViewCell.h"
#import "Macros.h"
#import "Member.h"

@interface MemberPasswordViewController ()

@property (nonatomic, retain) UITextField *oldPasswordTextField;
@property (nonatomic, retain) UITextField *changePasswordTextField;
@property (nonatomic, retain) UITextField *confirmPasswordTextField;
@property (nonatomic, retain) UIButton *saveButton;

@end

@implementation MemberPasswordViewController

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
    
    self.title = @"修改密码";
    
    
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


    self.oldPasswordTextField = [[UITextField alloc] init];
    self.oldPasswordTextField.secureTextEntry = YES;
    self.oldPasswordTextField.font = [UIFont systemFontOfSize:15.0];
    self.oldPasswordTextField.placeholder = @"请输入原密码";
    self.oldPasswordTextField.delegate = self;
    
    
    self.changePasswordTextField = [[UITextField alloc] init];
    self.changePasswordTextField.secureTextEntry = YES;
    self.changePasswordTextField.font = [UIFont systemFontOfSize:15.0];
    self.changePasswordTextField.placeholder = @"请输入新密码";
    self.changePasswordTextField.delegate = self;
    
    self.confirmPasswordTextField = [[UITextField alloc] init];
    self.confirmPasswordTextField.secureTextEntry = YES;
    self.confirmPasswordTextField.font = [UIFont systemFontOfSize:15.0];
    self.confirmPasswordTextField.placeholder = @"请再确认一次";
    self.confirmPasswordTextField.delegate = self;
    
    UIImage *buttonImage = [UIImage imageNamed:@"MemberCellButton"];
    self.saveButton = [[UIButton alloc] init];
    self.saveButton.frame = CGRectMake(0.0, 0.0, 270.0, buttonImage.size.height);
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:18.0];    
    [self.saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton addTarget:self
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
    NSString *oldPassword = self.oldPasswordTextField.text;
    NSString *changePassword = self.changePasswordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;
    
    if (oldPassword.length == 0) {
        [self.oldPasswordTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:self.oldPasswordTextField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (changePassword.length == 0) {
        [self.changePasswordTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:self.changePasswordTextField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (confirmPassword.length == 0) {
        [self.confirmPasswordTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:self.confirmPasswordTextField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([changePassword isEqualToString:confirmPassword] == NO) {
        [self.changePasswordTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"两次输入的密码不一致"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    [[UIApplication sharedApplication] resignFirstResponder];
    self.oldPasswordTextField.enabled = NO;
    self.changePasswordTextField.enabled = NO;
    self.confirmPasswordTextField.enabled = NO;
    self.saveButton.enabled = NO;
    
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
        Result *result = [[Member sharedMember] updatePassword:oldPassword changePassword:changePassword];
        if (result.isSuccess == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.oldPasswordTextField.text = @"";
                self.changePasswordTextField.text = @"";
                self.confirmPasswordTextField.text = @"";
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"密码修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
        self.oldPasswordTextField.enabled = YES;
        self.changePasswordTextField.enabled = YES;
        self.confirmPasswordTextField.enabled = YES;
        self.saveButton.enabled = YES;
        [activityIndicatorView removeFromSuperview];
    });

}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0;
    }
    
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        
        self.saveButton.frame = CGRectMake(25.0,
                                           0.0,
                                           self.saveButton.frame.size.width,
                                           self.saveButton.frame.size.height);
        [cell addSubview:self.saveButton];
        
        return cell;
    } else {
        MemberFieldTableViewCell *cell = [[MemberFieldTableViewCell alloc] init];
        if (indexPath.section == 0) {
            self.oldPasswordTextField.frame = CGRectMake(9.0,
                                                         0.0,
                                                         252.0,
                                                         [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [cell.contentView addSubview:self.oldPasswordTextField];
        } else if (indexPath.section == 1) {
            self.changePasswordTextField.frame = CGRectMake(9.0,
                                                            0.0,
                                                            252.0,
                                                            [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [cell.contentView addSubview:self.changePasswordTextField];
        } else if (indexPath.section == 2) {
            self.confirmPasswordTextField.frame = CGRectMake(9.0,
                                                             0.0,
                                                             252.0,
                                                             [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [cell.contentView addSubview:self.confirmPasswordTextField];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.oldPasswordTextField) {
        [self.changePasswordTextField becomeFirstResponder];
    } else if (textField == self.changePasswordTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
    } else if (textField == self.confirmPasswordTextField) {
        [self submit:nil];
    }
    
    return NO;
}


@end
