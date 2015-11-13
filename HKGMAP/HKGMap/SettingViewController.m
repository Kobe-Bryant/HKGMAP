//
//  SettingViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-21.
//
//

#define CLEAR_CACHE_ALERT_VIEW_TAG 0003
#define VERSION_ALERT_VIEW_TAG 0004


#import "SettingViewController.h"
#import "MemberCenterTableViewCell.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Macros.h"
#import "CustomMarcos.h"
#import "SystemSetting.h"

@interface SettingViewController ()

@property (nonatomic, retain) UISwitch *autoDownloadSwitchView;
@property (nonatomic, retain) UISwitch *displayImageSwitchView;
@property (nonatomic, retain) UISwitch *nofiticationSwitchView;
@property (nonatomic, retain) SystemSetting *systemSetting;

@end

@implementation SettingViewController

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
    self.title = @"设置";
    
    
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
    
    
    //
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.autoDownloadSwitchView = [[UISwitch alloc] init];
    [self.autoDownloadSwitchView setOn:[userDefaults boolForKey:IS_AUTO_DOWNLOAD_ON_WWAN]];
    [self.autoDownloadSwitchView addTarget:self
                                    action:@selector(autoDownloadSwitchChanged:)
                          forControlEvents:UIControlEventValueChanged];

    self.displayImageSwitchView = [[UISwitch alloc] init];
    [self.displayImageSwitchView setOn:[userDefaults boolForKey:IS_DISPLAY_IMAGE_ON_WWAN]];
    [self.displayImageSwitchView addTarget:self
                                    action:@selector(displayImageSwitchChanged:)
                          forControlEvents:UIControlEventValueChanged];
    
    self.nofiticationSwitchView = [[UISwitch alloc] init];
    self.nofiticationSwitchView.enabled = ([[userDefaults stringForKey:DEVICE_TOKEN] length] != 0);
    if (self.nofiticationSwitchView.enabled) {
        [self.nofiticationSwitchView setOn:[userDefaults boolForKey:ENABLED_ROMOTE_NOTIFICATION]];
    } else {
        [self.nofiticationSwitchView setOn:NO];
    }
    
    [self.nofiticationSwitchView addTarget:self
                                    action:@selector(notificationSwitchChanged:)
                          forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        Result *result = [SystemSetting versionInformation];
        if (result.isSuccess) {
            self.systemSetting = (SystemSetting *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
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

- (void)autoDownloadSwitchChanged:(UISwitch *)switchView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:switchView.on forKey:IS_AUTO_DOWNLOAD_ON_WWAN];
    [userDefaults synchronize];
}

- (void)displayImageSwitchChanged:(UISwitch *)switchView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:switchView.on forKey:IS_DISPLAY_IMAGE_ON_WWAN];
    [userDefaults synchronize];
}

- (void)notificationSwitchChanged:(UISwitch *)switchView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:switchView.on forKey:ENABLED_ROMOTE_NOTIFICATION];
    [userDefaults synchronize];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 40.0;
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0);
        
        UILabel *versionLabel = [[UILabel alloc] init];
        versionLabel.backgroundColor = [UIColor clearColor];
        versionLabel.textColor = UIColorFromRGB(176.0, 176.0, 176.0);
        versionLabel.font = [UIFont systemFontOfSize:12.0];
        versionLabel.text = [[NSString alloc] initWithFormat:@"当前版本V%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        [versionLabel sizeToFit];
        versionLabel.center = footerView.center;
        [footerView addSubview:versionLabel];
        
        return footerView;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 3) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"确认要清除缓存吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消", nil];
        alertView.tag = CLEAR_CACHE_ALERT_VIEW_TAG;
        [alertView show];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        AboutViewController *aboutVC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        if (self.systemSetting != nil && currentVersion.length > 0 && [self.systemSetting.version isEqualToString:currentVersion] == NO) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.systemSetting.updateVersionURLString]];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"暂无新版本"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            alertView.tag = VERSION_ALERT_VIEW_TAG;
            [alertView show];
        }
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
        return 3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MemberCenterTableViewCellStyle style;
        if (indexPath.row == 0) {
            style = MemberCenterTableViewFirstCell;
        } else if (indexPath.row == 3) {
            style = MemberCenterTableViewLastCell;
        } else {
            style = MemberCenterTableViewMinddleCell;
        }
        
        MemberCenterTableViewCell *cell = [[MemberCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 customCellStyle:style];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"2G/3G网络自动下载数据";
            cell.accessoryView = self.autoDownloadSwitchView;
            cell.accessoryView.layer.zPosition = 7001;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"2G/3G网络显示图片";
            cell.accessoryView = self.displayImageSwitchView;
            cell.accessoryView.layer.zPosition = 7002;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"消息推送通知";
            cell.accessoryView = self.nofiticationSwitchView;
            cell.accessoryView.layer.zPosition = 7003;
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"清除缓存";
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        MemberCenterTableViewCellStyle style;
        if (indexPath.row == 0) {
            style = MemberCenterTableViewFirstCell;
        } else if (indexPath.row == 2) {
            style = MemberCenterTableViewLastCell;
        } else {
            style = MemberCenterTableViewMinddleCell;
        }
        
        MemberCenterTableViewCell *cell = [[MemberCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault customCellStyle:style];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"意见反馈";
            [cell.textLabel sizeToFit];
            cell.textLabel.center = cell.contentView.center;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"关于我们";
            [cell.textLabel sizeToFit];
            cell.textLabel.center = cell.contentView.center;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"版本更新";
            [cell.textLabel sizeToFit];
            cell.textLabel.center = cell.contentView.center;
            
            NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];

            if (self.systemSetting != nil && currentVersion.length > 0 && [self.systemSetting.version isEqualToString:currentVersion] == NO) {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = [UIImage imageNamed:@"NewVersion"];
                imageView.frame = CGRectMake(CGRectGetMaxX(cell.textLabel.frame),
                                             ([self tableView:tableView heightForRowAtIndexPath:indexPath] - imageView.image.size.height) / 2.0,
                                             imageView.image.size.width,
                                             imageView.image.size.height);
                cell.accessoryView = imageView;
                cell.accessoryView.layer.zPosition = 7004;
            } else {
                cell.accessoryView = nil;
            }
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CLEAR_CACHE_ALERT_VIEW_TAG && buttonIndex == 0) {
        
        // Clear URL cache
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        
        // Clear image cache
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"缓存已成功清除"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
