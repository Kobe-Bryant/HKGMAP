//
//  FeedbackViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-18.
//
//

#import "FeedbackViewController.h"
#import "FeedbackTableViewCell.h"
//#import "MemberButtonTableViewCell.h"
//#import "GCPlaceholderTextView.h"
#import "SZTextView.h"
#import "Macros.h"
#import "Feedback.h"
#import "NSString+Validator.h"

@interface FeedbackViewController ()

@property (nonatomic, retain) UITextField *emailTextField;
@property (nonatomic, retain) SZTextView *messageTextView;
@property (nonatomic, retain) UIButton *saveButton;

@end

@implementation FeedbackViewController

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
    
    self.title = @"意见反馈";
    
    
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
    
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.backgroundColor = [UIColor whiteColor];
    if ([self.emailTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入邮箱" attributes:[[NSDictionary alloc] initWithObjectsAndKeys:UIColorFromRGB(170.0, 170.0, 170.0), NSForegroundColorAttributeName, nil]];
    } else {
        self.emailTextField.placeholder = @"请输入邮箱";
    }
    self.emailTextField.font = [UIFont systemFontOfSize:15.0];
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.delegate = self;
    
    self.messageTextView = [[SZTextView alloc] init];
    self.messageTextView.backgroundColor = [UIColor whiteColor];
    self.messageTextView.placeholder = @"请输入您的意见";
    self.messageTextView.placeholderTextColor = UIColorFromRGB(170.0, 170.0, 170.0);
    self.messageTextView.font = [UIFont systemFontOfSize:15.0];
    
    UIImage *buttonImage = [UIImage imageNamed:@"MemberCellButton"];
    self.saveButton = [[UIButton alloc] init];
    self.saveButton.frame = CGRectMake(0.0, 0.0, 270.0, buttonImage.size.height);
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.saveButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchDown];
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
    Feedback *feedback = [[Feedback alloc] init];
    feedback.email = self.emailTextField.text;
    feedback.message = self.messageTextView.text;
    
    if (feedback.email.length == 0) {
        [self.emailTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:self.emailTextField.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([feedback.email isEmail] == NO) {
        [self.emailTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"邮箱格式不正确"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (feedback.message.length == 0) {
        [self.messageTextView becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:self.messageTextView.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [[UIApplication sharedApplication] resignFirstResponder];
    self.emailTextField.enabled = NO;
    [self.messageTextView setEditable:NO];
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
        Result *result = [feedback save];
        if (result.isSuccess == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.emailTextField.text = @"";
                self.messageTextView.text = @"";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
        self.emailTextField.enabled = YES;
        [self.messageTextView setEditable:YES];
        self.saveButton.enabled = YES;
        [activityIndicatorView removeFromSuperview];
    });
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 15.0;
    } else if (indexPath.section == 2) {
        return 180.0;
    }
        
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 25.0;
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
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0.0,
                                      0.0,
                                      tableView.frame.size.width,
                                      [self tableView:tableView heightForRowAtIndexPath:indexPath]);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = UIColorFromRGB(170.0, 170.0, 170.0);
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        titleLabel.text = @"      欢迎您提交宝贵的意见和建议。";
        [cell addSubview:titleLabel];
        
        return cell;
    } else if (indexPath.section == 1) {
        FeedbackTableViewCell *cell = [[FeedbackTableViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
        
        self.emailTextField.frame = CGRectMake(9.0,
                                               0.0,
                                               252.0,
                                               cell.frame.size.height);
        [cell.contentView addSubview:self.emailTextField];
        
        return cell;
    } else if (indexPath.section == 2) {
        FeedbackTableViewCell *cell = [[FeedbackTableViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
        
        self.messageTextView.frame = CGRectMake(4.0,
                                                0.0,
                                                257.0,
                                                [self tableView:tableView heightForRowAtIndexPath:indexPath]);
        [cell.contentView addSubview:self.messageTextView];
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        
        self.saveButton.frame = CGRectMake(25.0,
                                           0.0,
                                           self.saveButton.frame.size.width,
                                           self.saveButton.frame.size.height);
        [cell addSubview:self.saveButton];
        
        return cell;
    }
    return nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [self.messageTextView becomeFirstResponder];
    }
    
    return NO;
}


@end
