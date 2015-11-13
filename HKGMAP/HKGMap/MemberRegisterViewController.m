//
//  MemberRegisterViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-21.
//
//

#import "MemberRegisterViewController.h"
#import "MemberFieldTableViewCell.h"
#import "Macros.h"
#import "Member.h"
#import "NSString+Validator.h"

@interface MemberRegisterViewController ()

@property (nonatomic, retain) UITextField *usernameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UITextField *confirmPasswordTextField;
@property (nonatomic, retain) UIImageView *isAgreedImageView;
@property (nonatomic, retain) UILabel *isAgreedTipsLabel;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, readwrite) BOOL isAgreed;

@end

@implementation MemberRegisterViewController

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
    self.title = @"注册";
    
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
    
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.font = [UIFont systemFontOfSize:15.0];
    self.passwordTextField.placeholder = @"请输入您的密码";
    self.passwordTextField.delegate = self;
    
    self.confirmPasswordTextField = [[UITextField alloc] init];
    self.confirmPasswordTextField.secureTextEntry = YES;
    self.confirmPasswordTextField.font = [UIFont systemFontOfSize:15.0];
    self.confirmPasswordTextField.placeholder = @"请再确认一次您的密码";
    self.confirmPasswordTextField.delegate = self;
    
    self.isAgreedImageView = [[UIImageView alloc] init];
    self.isAgreedImageView.image = [UIImage imageNamed:@"CheckBoxSelected"];
    self.isAgreedImageView.frame = CGRectMake(0.0,
                                              0.0,
                                              self.isAgreedImageView.image.size.width,
                                              self.isAgreedImageView.image.size.height);
    self.isAgreed = YES;
    
    self.isAgreedTipsLabel = [[UILabel alloc] init];
    self.isAgreedTipsLabel.backgroundColor = [UIColor clearColor];
    self.isAgreedTipsLabel.font = [UIFont systemFontOfSize:15.0];
    self.isAgreedTipsLabel.textColor = UIColorFromRGB(170.0, 170.0, 170.0);
    self.isAgreedTipsLabel.text = @"我已阅读并接受注册协议";
    [self.isAgreedTipsLabel sizeToFit];
    
    UIImage *buttonImage = [UIImage imageNamed:@"MemberCellButton"];
    self.saveButton = [[UIButton alloc] init];
    self.saveButton.frame = CGRectMake(0.0, 0.0, 270.0, buttonImage.size.height);
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.saveButton setTitle:@"免费注册" forState:UIControlStateNormal];
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
    Member *member = [[Member alloc] init];
    member.loginUsername = self.usernameTextField.text;
    member.loginPassword = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;
    
    if (member.loginUsername.length == 0) {
        [self.usernameTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:self.usernameTextField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([member.loginUsername isEmail] == NO) {
        [self.usernameTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"邮箱格式不正确"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (member.loginPassword.length == 0) {
        [self.passwordTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:self.passwordTextField.placeholder
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
    if ([member.loginPassword isEqualToString:confirmPassword] == NO) {
        [self.passwordTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"两次输入的密码不一致"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (self.isAgreed == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"您需要阅读并接受注册协议后才能注册"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [[UIApplication sharedApplication] resignFirstResponder];
    self.usernameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
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
        Result *result = [member toRegister];
        if (result.isSuccess == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.usernameTextField.text = @"";
                self.passwordTextField.text = @"";
                self.confirmPasswordTextField.text = @"";
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已成功注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
        self.passwordTextField.enabled = YES;
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
    } else {
        return 15.0;
    }
    return 0.0;
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
    return 5;
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
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        self.isAgreedImageView.frame = CGRectMake(25.0,
                                                  ([self tableView:tableView heightForRowAtIndexPath:indexPath] - self.isAgreedImageView.frame.size.height) / 2.0,
                                                  self.isAgreedImageView.frame.size.width,
                                                  self.isAgreedImageView.frame.size.height);
        [cell addSubview:self.isAgreedImageView];
        
        self.isAgreedTipsLabel.frame = CGRectMake(CGRectGetMaxX(self.isAgreedImageView.frame) + 10.0,
                                                  ([self tableView:tableView heightForRowAtIndexPath:indexPath] - self.isAgreedTipsLabel.frame.size.height) / 2.0,
                                                  self.isAgreedTipsLabel.frame.size.width,
                                                  self.isAgreedTipsLabel.frame.size.height);
        [cell addSubview:self.isAgreedTipsLabel];
        
        return cell;
    } else if (indexPath.section == 4) {
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
            self.usernameTextField.frame = CGRectMake(9.0,
                                                      0.0,
                                                      252.0,
                                                      [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [cell.contentView addSubview:self.usernameTextField];
        } else if (indexPath.section == 1) {
            self.passwordTextField.frame = CGRectMake(9.0,
                                                      0.0,
                                                      252.0,
                                                      [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [cell.contentView addSubview:self.passwordTextField];
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

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        self.isAgreed = !self.isAgreed;
        if (self.isAgreed) {
            self.isAgreedImageView.image = [UIImage imageNamed:@"CheckBoxSelected"];
        } else {
            self.isAgreedImageView.image = [UIImage imageNamed:@"CheckBoxUnselected"];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
    } else if (textField == self.confirmPasswordTextField) {
        [self submit:nil];
    }
    
    return NO;
}

@end
