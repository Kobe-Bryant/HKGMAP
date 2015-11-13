//
//  MemberProfileViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-24.
//
//

#define CONTROL_HEIGHT 216.0

#import "MemberProfileViewController.h"
#import "MemberFieldTableViewCell.h"
#import "Macros.h"
#import "Member.h"
#import "NSString+Validator.h"

@interface MemberProfileViewController ()

@property (nonatomic, retain) Member *member;
@property (nonatomic, retain) UITextField *usernameTextField;
@property (nonatomic, retain) UITextField *genderTextField;
@property (nonatomic, retain) UIPickerView *genderPickerView;
@property (nonatomic, retain) UITextField *birthdayTextField;
@property (nonatomic, retain) UIDatePicker* birthdayDatePicker;
@property (nonatomic, retain) UITextField *emailTextField;
@property (nonatomic, retain) UITextField *mobileTextField;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, readwrite) BOOL isShowedControl;

@end

@implementation MemberProfileViewController

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
    
    self.title = @"账户信息";
    
    
    
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
    self.usernameTextField.delegate = self;
    [self.usernameTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];

    
//    UILabel *usernameLabel = [[UILabel alloc] init];
//    usernameLabel.text = @"test";
//    [usernameLabel sizeToFit];
//    self.usernameTextField.inputAccessoryView = usernameLabel;
    
    
    self.genderPickerView = [[UIPickerView alloc] init];
    self.genderPickerView.delegate = self;
    self.genderPickerView.dataSource = self;
    
    self.genderTextField = [[UITextField alloc] init];
    self.genderTextField.font = [UIFont systemFontOfSize:15.0];
    self.genderTextField.delegate = self;
    self.genderTextField.inputView = self.genderPickerView;
    [self.genderTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];

    
    
    self.birthdayDatePicker = [[UIDatePicker alloc] init];
    self.birthdayDatePicker.datePickerMode = UIDatePickerModeDate;
    self.birthdayDatePicker.maximumDate = [NSDate date];
    [self.birthdayDatePicker addTarget:self
                                action:@selector(birthdayChanged:)
                      forControlEvents:UIControlEventValueChanged];

    self.birthdayTextField = [[UITextField alloc] init];
    self.birthdayTextField.font = [UIFont systemFontOfSize:15.0];
    self.birthdayTextField.delegate = self;
    self.birthdayTextField.inputView = self.birthdayDatePicker;
    [self.birthdayTextField addTarget:self
                             action:@selector(textFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];

    
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.font = [UIFont systemFontOfSize:15.0];
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.delegate = self;
    [self.emailTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];

    self.mobileTextField = [[UITextField alloc] init];
    self.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTextField.font = [UIFont systemFontOfSize:15.0];
    self.mobileTextField.delegate = self;
    [self.mobileTextField addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];

    
    UIImage *buttonImage = [UIImage imageNamed:@"MemberCellButton"];
    self.saveButton = [[UIButton alloc] init];
    self.saveButton.frame = CGRectMake(0.0, 0.0, 270.0, buttonImage.size.height);
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton addTarget:self
                        action:@selector(submit:)
              forControlEvents:UIControlEventTouchDown];
 
    
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showControl:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideControl:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
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
        Result *result = [[Member sharedMember] profile];
        if (result.isSuccess) {
            self.member = (Member *)result.data;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.usernameTextField.text = self.member.name;
                if (self.member.gender == 0) {
                    self.genderTextField.text = @"男";
                } else {
                    self.genderTextField.text = @"女";
                }
                self.birthdayTextField.text = self.member.birthday;
                self.emailTextField.text = self.member.email;
                self.mobileTextField.text = self.member.mobile;
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)birthdayChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.birthdayTextField.text = [dateFormatter stringFromDate:[datePicker date]];
    self.member.birthday = self.birthdayTextField.text;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        self.member.name = textField.text;
    } else if (textField == self.genderTextField) {
        if ([self.genderTextField.text isEqualToString:@"男"]) {
            self.member.gender = YES;
        } else {
            self.member.gender = NO;
        }
    } else if (textField == self.birthdayTextField) {
        self.member.birthday = textField.text;
    } else if (textField == self.emailTextField) {
        self.member.email = textField.text;
    } else if (textField == self.mobileTextField) {
        self.member.mobile = textField.text;
    }
}

- (void)showControl:(NSNotification *)notification
{
    if (self.isShowedControl == NO) {
        self.isShowedControl = YES;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                          self.tableView.frame.origin.y,
                                          self.tableView.frame.size.width,
                                          self.view.frame.size.height - CONTROL_HEIGHT);
    }
}


- (void)hideControl:(NSNotification *)notification
{
    if (self.isShowedControl == YES) {
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                          self.tableView.frame.origin.y,
                                          self.tableView.frame.size.width,
                                          self.view.frame.size.height);
        self.isShowedControl = NO;
    }
}

- (void)submit:(UIButton *)button
{
    if (self.member.name.length == 0) {
//        [self.usernameTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请输入姓名"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (self.member.birthday.length == 0) {
//        [self.birthdayTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请选择出生日期"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (self.member.email.length == 0) {
//        [self.emailTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请输入邮箱"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;

    }
    if (self.member.mobile.length == 0) {
//        [self.mobileTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请输入手机"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
        
    }
    if ([self.member.email isEmail] == NO) {
//        [self.emailTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"邮箱格式错误"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
        
    }
    if ([self.member.mobile isMobile] == NO) {
//        [self.mobileTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"手机格式错误"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
        
    }
    
    
    [[UIApplication sharedApplication] resignFirstResponder];
//    self.usernameTextField.enabled = NO;
//    self.genderTextField.enabled = NO;
//    self.birthdayTextField.enabled = NO;
//    self.emailTextField.enabled = NO;
//    self.mobileTextField.enabled = NO;
//    self.saveButton.enabled = NO;
    
    
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
        Result *result = [self.member updateProfile];
        if (result.isSuccess == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"账号信息修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
//        self.usernameTextField.enabled = YES;
//        self.genderTextField.enabled = YES;
//        self.birthdayTextField.enabled = YES;
//        self.emailTextField.enabled = YES;
//        self.mobileTextField.enabled = YES;
//        self.saveButton.enabled = YES;
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
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    if (indexPath.section == 5) {
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
            cell.textLabel.text = @"       姓名：";
            self.usernameTextField.frame = CGRectMake(90.0,
                                                      0.0,
                                                      190.0,
                                                      [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [cell.contentView addSubview:self.usernameTextField];
        } else if (indexPath.section == 1) {
            cell.textLabel.text = @"       性别：";
            self.genderTextField.frame = CGRectMake(90.0,
                                                    0.0,
                                                    190.0,
                                                    [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [cell.contentView addSubview:self.genderTextField];
        } else if (indexPath.section == 2) {
            cell.textLabel.text = @"出生日期：";
            self.birthdayTextField.frame = CGRectMake(90.0,
                                                      0.0,
                                                      190.0,
                                                      [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [cell.contentView addSubview:self.birthdayTextField];
        } else if (indexPath.section == 3) {
            cell.textLabel.text = @"       邮箱：";
            self.emailTextField.frame = CGRectMake(90.0,
                                                   0.0,
                                                   190.0,
                                                   [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [cell.contentView addSubview:self.emailTextField];
        } else if (indexPath.section == 4) {
            cell.textLabel.text = @"       手机：";
            self.mobileTextField.frame = CGRectMake(90.0,
                                                    0.0,
                                                    190.0,
                                                    [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [cell.contentView addSubview:self.mobileTextField];
        }

        return cell;
    }
        
    return nil;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"男";
    } else if (row == 1) {
        return @"女";
    }
    return nil;
}

#pragma mark - UIPickerViewDataDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.genderTextField.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    if ([self.genderTextField.text isEqualToString:@"男"]) {
        self.member.gender = YES;
    } else {
        self.member.gender = NO;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        [self.genderTextField becomeFirstResponder];
    } else if (textField == self.genderTextField) {
        [self.birthdayTextField becomeFirstResponder];
    } else if (textField == self.birthdayTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.mobileTextField becomeFirstResponder];
    } else if (textField == self.mobileTextField) {
        [self submit:nil];
    }
    
    return NO;
}

@end

