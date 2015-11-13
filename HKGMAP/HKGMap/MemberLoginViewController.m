//
//  MemberLoginViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-21.
//
//

#import "MemberLoginViewController.h"
#import "MemberFieldTableViewCell.h"
#import "MemberFindPasswordViewController.h"
#import "MemberRegisterViewController.h"
#import "Macros.h"
#import "Member.h"
#import "NSString+Validator.h"
#import "CustomMarcos.h"

@interface MemberLoginViewController ()

@property (nonatomic, retain) UITextField *usernameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UILabel *forgotPasswordLabel;
@property (nonatomic, retain) UIView *separatorLineView;
@property (nonatomic, retain) UILabel *registerTipsLabel;
@property (nonatomic, retain) UIButton *registerButton;

@end

@implementation MemberLoginViewController

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
    self.title = @"登录";
    
    
    // Navigation bar
    UIImage *closeIcon = [UIImage imageNamed:@"CloseIcon"];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0.0,
                                   0.0,
                                   closeIcon.size.width,
                                   closeIcon.size.height);
    [closeButton setImage:closeIcon forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = closeButtonItem;

    
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

    UIImage *loginButtonImage = [UIImage imageNamed:@"MemberCellButton"];
    self.loginButton = [[UIButton alloc] init];
    self.loginButton.frame = CGRectMake(0.0, 0.0, 270.0, loginButtonImage.size.height);
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.loginButton setBackgroundImage:loginButtonImage forState:UIControlStateNormal];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self
                         action:@selector(submit:)
               forControlEvents:UIControlEventTouchDown];

    self.forgotPasswordLabel = [[UILabel alloc] init];
    self.forgotPasswordLabel.backgroundColor = [UIColor clearColor];
    self.forgotPasswordLabel.font = [UIFont systemFontOfSize:15.0];
    self.forgotPasswordLabel.textColor = UIColorFromRGB(170.0, 170.0, 170.0);
    self.forgotPasswordLabel.text = @"忘记密码？";
    [self.forgotPasswordLabel sizeToFit];
    self.forgotPasswordLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(forgotPassword:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.forgotPasswordLabel addGestureRecognizer:tap];
    
    self.separatorLineView = [[UIView alloc] init];
    self.separatorLineView.frame = CGRectMake(0.0, 0.0, 270.0, 1.0);
    self.separatorLineView.backgroundColor = UIColorFromRGB(211.0, 204.0, 193.0);
    
    self.registerTipsLabel = [[UILabel alloc] init];
    self.registerTipsLabel.backgroundColor = [UIColor clearColor];
    self.registerTipsLabel.font =  [UIFont systemFontOfSize:15.0];
    self.registerTipsLabel.textColor = UIColorFromRGB(170.0, 170.0, 170.0);
    self.registerTipsLabel.text = @"如您还没有账户，请在这里注册";
    [self.registerTipsLabel sizeToFit];
    
    UIImage *registerButtonImage = [UIImage imageNamed:@"MemberCellButton3"];
    self.registerButton = [[UIButton alloc] init];
    self.registerButton.frame = CGRectMake(0.0, 0.0, 270.0, loginButtonImage.size.height);
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.registerButton setBackgroundImage:registerButtonImage forState:UIControlStateNormal];
    [self.registerButton setTitleColor:UIColorFromRGB(139.0, 139.0, 130.0)
                              forState:UIControlStateNormal];
    [self.registerButton setTitle:@"免费注册" forState:UIControlStateNormal];
    [self.registerButton addTarget:self
                            action:@selector(goRegister:)
                  forControlEvents:UIControlEventTouchDown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)close:(UIButton *)button
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)submit:(UIButton *)button
{
    Member *member = [[Member alloc] init];
    member.loginUsername = self.usernameTextField.text;
    member.loginPassword = self.passwordTextField.text;
    
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
    
    
    [[UIApplication sharedApplication] resignFirstResponder];
    self.usernameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    self.loginButton.enabled = NO;
    
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
        Result *result = [member login];
        if (result.isSuccess == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.usernameTextField.text = @"";
                self.passwordTextField.text = @"";
                [self close:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_STATUS_CHANGE_NOTIFICATION
                                                                    object:self
                                                                  userInfo:nil];
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
        self.loginButton.enabled = YES;
        [activityIndicatorView removeFromSuperview];
    });
}

- (void)goRegister:(UIButton *)button
{
    MemberRegisterViewController *registerVC = [[MemberRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)forgotPassword:(UIGestureRecognizer *)gestureRecognizer
{
    MemberFindPasswordViewController *findPasswordVC = [[MemberFindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findPasswordVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 7;
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
        MemberFieldTableViewCell *cell = [[MemberFieldTableViewCell alloc] init];
        self.passwordTextField.frame = CGRectMake(9.0,
                                                  0.0,
                                                  252.0,
                                                  [self tableView:tableView heightForRowAtIndexPath:indexPath]);
        [cell.contentView addSubview:self.passwordTextField];
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        self.loginButton.frame = CGRectMake(25.0,
                                            0.0,
                                            self.loginButton.frame.size.width,
                                            self.loginButton.frame.size.height);
        [cell addSubview:self.loginButton];
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        self.forgotPasswordLabel.frame = CGRectMake(tableView.frame.size.width - 25.0 - self.forgotPasswordLabel.frame.size.width,
                                                    0.0,
                                                    self.forgotPasswordLabel.frame.size.width,
                                                    self.forgotPasswordLabel.frame.size.height);
        [cell addSubview:self.forgotPasswordLabel];
        return cell;
    } else if (indexPath.section == 4) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        self.separatorLineView.frame = CGRectMake((tableView.frame.size.width - self.separatorLineView.frame.size.width) / 2.0,
                                                  0.0,
                                                  self.separatorLineView.frame.size.width,
                                                  self.separatorLineView.frame.size.height);
        [cell addSubview:self.separatorLineView];
        return cell;
    } else if (indexPath.section == 5) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        self.registerTipsLabel.frame = CGRectMake((tableView.frame.size.width - self.registerTipsLabel.frame.size.width) / 2.0,
                                                  ([self tableView:tableView heightForRowAtIndexPath:indexPath] - self.registerTipsLabel.frame.size.height) / 2.0,
                                                  self.registerTipsLabel.frame.size.width,
                                                  self.registerTipsLabel.frame.size.height);
        [cell addSubview:self.registerTipsLabel];
        return cell;
    } else if (indexPath.section == 6) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        self.registerButton.frame = CGRectMake(25.0,
                                               0.0,
                                               self.registerButton.frame.size.width,
                                               self.registerButton.frame.size.height);
        [cell addSubview:self.registerButton];
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
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self submit:nil];
    }
    
    return NO;
}


@end
