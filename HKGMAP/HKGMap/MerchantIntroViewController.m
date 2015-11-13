//
//  MerchantIntroViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import "MerchantIntroViewController.h"
#import "MerchantIntroGalleryViewController.h"
#import "ProductListViewController.h"
#import "MerchantBranchListViewController.h"
#import "InformationDetailViewController.h"
#import "CalendarInformationCell.h"
#import "MemberLoginViewController.h"
#import "ViewSize.h"
#import "Macros.h"
#import "Member.h"
#import "Merchant.h"
#import "Discount.h"

//#define kBackgroundColor [UIColor colorWithRed:(242.0/255.0) green:(239.0/255.0) blue:(235.0/255.0) alpha:1.0]

#define kGalleryWidth 320.0
#define kGalleryHeight 200.0

//#define kTitleFontColor [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0]
//#define kSnippetFontColor [UIColor colorWithRed:(176.0/255.0) green:(176.0/255.0) blue:(176.0/255.0) alpha:1.0]
//#define kFollowFontColor [UIColor colorWithRed:(139.0/255.0) green:(139.0/255.0) blue:(139.0/255.0) alpha:1.0]
//#define kQuantityFontColor [UIColor colorWithRed:(187.0/255.0) green:(45.0/255.0) blue:(26.0/255.0) alpha:1.0]
//#define kLineColor [UIColor colorWithRed:(244.0/255.0) green:(244.0/255.0) blue:(244.0/255.0) alpha:1.0]

#define kItemY 5.0
#define kItemHeight 60.0
#define FOLLOW_BUTTON 4301


@interface MerchantIntroViewController ()

@property (nonatomic, readwrite) BOOL isViewWillAppeared;
@property (nonatomic, retain) NSNumber *merchantID;
@property (nonatomic, retain) Merchant *merchant;

@end

@implementation MerchantIntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDataObject:(id)dataObject
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.merchantID = dataObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"商户介绍";
    self.view.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
    
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


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
    
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
        Member *member = [Member sharedMember];
        Result *result = [Merchant requestOne:member.memberID merchantID:self.merchantID];
        if (result.isSuccess) {
            self.merchant = (Merchant *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                // Scroll view
                UIScrollView *scrollView = [[UIScrollView alloc] init];
                scrollView.frame = CGRectMake(0.0,
                                              0.0,
                                              self.view.frame.size.width,
                                              self.view.frame.size.height);
                [self.view addSubview:scrollView];
                
                
                
                // Gallery
                MerchantIntroGalleryViewController *galleryVC = [[MerchantIntroGalleryViewController alloc] initWithDataObject:self.merchant.merchantGalleryArray];
                galleryVC.view.frame = CGRectMake(0.0,
                                                  0.0,
                                                  self.view.frame.size.width,
                                                  kGalleryHeight);
                galleryVC.view.hidden = ([self.merchant.merchantGalleryArray count] == 0);
                [self addChildViewController:galleryVC];
                [scrollView addSubview:galleryVC.view];
                
                
                
                // Title
                UILabel *titleLabel = [[UILabel alloc] init];
                if (galleryVC.view.hidden) {
                    titleLabel.frame = CGRectMake(15.0,
                                                  20.0,
                                                  335.0,
                                                  titleLabel.frame.size.height);
                } else {
                    titleLabel.frame = CGRectMake(15.0,
                                                  CGRectGetMaxY(galleryVC.view.frame) + 20.0,
                                                  335.0,
                                                  titleLabel.frame.size.height);
                }
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.font = [UIFont systemFontOfSize:20.0];
                titleLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
                titleLabel.numberOfLines = 1;
                titleLabel.text = self.merchant.merchantName;
                [titleLabel sizeToFit];
                [scrollView addSubview:titleLabel];
                
                
                // Address
                UILabel *addressLabel = [[UILabel alloc] init];
                addressLabel.frame = CGRectMake(titleLabel.frame.origin.x,
                                                CGRectGetMaxY(titleLabel.frame) + 13.0,
                                                titleLabel.frame.size.width,
                                                11.0);
                addressLabel.backgroundColor = [UIColor clearColor];
                addressLabel.textColor = UIColorFromRGB(176.0, 176.0, 176.0);
                addressLabel.font = [UIFont systemFontOfSize:11.0];
                addressLabel.text = [[NSString alloc] initWithFormat:@"地址：%@", self.merchant.address];
                [addressLabel sizeToFit];
                [scrollView addSubview:addressLabel];
                
                
                // Traffic
                UILabel *trafficLabel = [[UILabel alloc] init];
                trafficLabel.frame = CGRectMake(titleLabel.frame.origin.x,
                                                CGRectGetMaxY(addressLabel.frame) + 5.0,
                                                titleLabel.frame.size.width,
                                                11.0);
                trafficLabel.backgroundColor = [UIColor clearColor];
                trafficLabel.textColor = UIColorFromRGB(176.0, 176.0, 176.0);
                trafficLabel.font = [UIFont systemFontOfSize:11.0];
                trafficLabel.text = [[NSString alloc] initWithFormat:@"交通：%@", self.merchant.traffic];
                [trafficLabel sizeToFit];
                [scrollView addSubview:trafficLabel];
                
                
                // Telephone
                UILabel *telephoneLabel = [[UILabel alloc] init];
                telephoneLabel.frame = CGRectMake(titleLabel.frame.origin.x,
                                                  CGRectGetMaxY(trafficLabel.frame) + 5.0,
                                                  titleLabel.frame.size.width,
                                                  11.0);
                telephoneLabel.backgroundColor = [UIColor clearColor];
                telephoneLabel.textColor = UIColorFromRGB(176.0, 176.0, 176.0);
                telephoneLabel.font = [UIFont systemFontOfSize:11.0];
                telephoneLabel.text = [[NSString alloc] initWithFormat:@"电话：%@", self.merchant.contact];
                [telephoneLabel sizeToFit];
                [scrollView addSubview:telephoneLabel];
                
                
                // Follow
                UIImage *followButtonImage = [UIImage imageNamed:@"MerchantFollowButton"];
                UIButton *followButton = [UIButton buttonWithType:UIButtonTypeCustom];
                followButton.frame = CGRectMake(215.0,
                                                titleLabel.frame.origin.y - 10.0,
                                                followButtonImage.size.width,
                                                followButtonImage.size.height);
                [followButton setBackgroundImage:followButtonImage forState:UIControlStateNormal];
                followButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
                if (self.merchant.hasCollect) {
                    [followButton setTitle:@"删关注" forState:UIControlStateNormal];
                } else {
                    [followButton setTitle:@"加关注" forState:UIControlStateNormal];
                }
                
                [followButton setTitleColor:UIColorFromRGB(139.0, 139.0, 139.0)
                                   forState:UIControlStateNormal];
                [followButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 0.0)];
                [followButton addTarget:self
                                 action:@selector(follow:)
                       forControlEvents:UIControlEventTouchUpInside];
                followButton.tag = FOLLOW_BUTTON;
                [scrollView addSubview:followButton];
                
                
                // Product
                UIView *productView = [[UIView alloc] init];
                productView.frame = CGRectMake(titleLabel.frame.origin.x,
                                               CGRectGetMaxY(telephoneLabel.frame) + 17.0,
                                               290.0,
                                               40.0);
                productView.backgroundColor = [UIColor whiteColor];
                [scrollView addSubview:productView];
                
                
                UILabel *productTipsLabel = [[UILabel alloc] init];
                productTipsLabel.frame = CGRectMake(15.0,
                                                    15.0,
                                                    120.0,
                                                    15.0);
                productTipsLabel.backgroundColor = [UIColor clearColor];
                productTipsLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
                productTipsLabel.font = [UIFont systemFontOfSize:15.0];
                productTipsLabel.text = @"新品";
                [productTipsLabel sizeToFit];
                [productView addSubview:productTipsLabel];
                
                
                UILabel *productQuantityLabel = [[UILabel alloc] init];
                productQuantityLabel.backgroundColor = [UIColor clearColor];
                productQuantityLabel.font = [UIFont boldSystemFontOfSize:15.0];
                productQuantityLabel.textColor = UIColorFromRGB(187.0, 45.0, 26.0);
                productQuantityLabel.text = [self.merchant.productCount stringValue];
                [productQuantityLabel sizeToFit];
                productQuantityLabel.frame = CGRectMake(productView.frame.size.width - productQuantityLabel.frame.size.width - 35.0,
                                                        productTipsLabel.frame.origin.y,
                                                        productQuantityLabel.frame.size.width,
                                                        productQuantityLabel.frame.size.height);
                [productView addSubview:productQuantityLabel];
                
                
                UILabel *productUnitLabel = [[UILabel alloc] init];
                productUnitLabel.frame = CGRectMake(CGRectGetMaxX(productQuantityLabel.frame) + 5.0,
                                                    productQuantityLabel.frame.origin.y,
                                                    20.0,
                                                    productUnitLabel.frame.size.height);
                productUnitLabel.backgroundColor = [UIColor clearColor];
                productUnitLabel.font = [UIFont systemFontOfSize:15.0];
                productUnitLabel.textColor = [UIColor grayColor];
                productUnitLabel.text = @"件";
                [productUnitLabel sizeToFit];
                [productView addSubview:productUnitLabel];
                
                
                UITapGestureRecognizer *productTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(productPressed:)];
                productTap.numberOfTapsRequired = 1;
                productTap.numberOfTouchesRequired = 1;
                [productView addGestureRecognizer:productTap];
                
                
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(productView.frame.origin.x,
                                            CGRectGetMaxY(productView.frame),
                                            productView.frame.size.width,
                                            1.0);
                lineView.backgroundColor = UIColorFromRGB(244.0, 244.0, 244.0);
                [scrollView addSubview:lineView];
                
                
                // Branch
                UIView *branchView = [[UIView alloc] init];
                branchView.frame = CGRectMake(lineView.frame.origin.x,
                                              CGRectGetMaxY(lineView.frame),
                                              lineView.frame.size.width,
                                              48.0);
                branchView.backgroundColor = [UIColor whiteColor];
                [scrollView addSubview:branchView];
                
                UILabel *branchTipsLabel = [[UILabel alloc] init];
                branchTipsLabel.frame = CGRectMake(15.0,
                                                   11.0,
                                                   120.0,
                                                   15.0);
                branchTipsLabel.backgroundColor = [UIColor clearColor];
                branchTipsLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
                branchTipsLabel.font = [UIFont systemFontOfSize:15.0];
                branchTipsLabel.text = @"分店";
                [branchTipsLabel sizeToFit];
                [branchView addSubview:branchTipsLabel];
                
                UILabel *branchQuantityLabel = [[UILabel alloc] init];
                branchQuantityLabel.backgroundColor = [UIColor clearColor];
                branchQuantityLabel.font = [UIFont boldSystemFontOfSize:15.0];
                branchQuantityLabel.textColor = UIColorFromRGB(187.0, 45.0, 26.0);
                branchQuantityLabel.text = [self.merchant.storeCount stringValue];
                [branchQuantityLabel sizeToFit];
                branchQuantityLabel.frame = CGRectMake(productView.frame.size.width - branchQuantityLabel.frame.size.width - 35.0,
                                                       branchTipsLabel.frame.origin.y,
                                                       branchQuantityLabel.frame.size.width,
                                                       branchQuantityLabel.frame.size.height);
                [branchView addSubview:branchQuantityLabel];
                
                
                UILabel *branchUnitLabel = [[UILabel alloc] init];
                branchUnitLabel.frame = CGRectMake(CGRectGetMaxX(branchQuantityLabel.frame) + 5.0,
                                                   branchQuantityLabel.frame.origin.y,
                                                   20.0,
                                                   branchUnitLabel.frame.size.height);
                branchUnitLabel.backgroundColor = [UIColor clearColor];
                branchUnitLabel.font = [UIFont systemFontOfSize:15.0];
                branchUnitLabel.textColor = [UIColor grayColor];
                branchUnitLabel.text = @"家";
                [branchUnitLabel sizeToFit];
                [branchView addSubview:branchUnitLabel];
                
                
                UIImageView *branchButtomImageView = [[UIImageView alloc] init];
                branchButtomImageView.image = [UIImage imageNamed:@"InformationFrameButtom"];
                branchButtomImageView.frame = CGRectMake(0.0,
                                                         branchView.frame.size.height - branchButtomImageView.image.size.height,
                                                         branchButtomImageView.image.size.width,
                                                         branchButtomImageView.image.size.height);
                [branchView addSubview:branchButtomImageView];
                
                UITapGestureRecognizer *branchTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(branchPressed:)];
                branchTap.numberOfTapsRequired = 1;
                branchTap.numberOfTouchesRequired = 1;
                [branchView addGestureRecognizer:branchTap];
                
                
                UILabel *mainTitleLabel = [[UILabel alloc] init];
                mainTitleLabel.frame = CGRectMake(titleLabel.frame.origin.x,
                                                  CGRectGetMaxY(branchView.frame) + 16.0,
                                                  self.view.frame.size.width,
                                                  20.0);
                mainTitleLabel.backgroundColor = [UIColor clearColor];
                mainTitleLabel.textColor = [UIColor grayColor];
                mainTitleLabel.font = [UIFont systemFontOfSize:15.0];
                mainTitleLabel.text = @"近期活动";
                [mainTitleLabel sizeToFit];
                [scrollView addSubview:mainTitleLabel];
                
                
                CGFloat activityViewHeight = mainTitleLabel.frame.size.height;
                activityViewHeight += 15.0;
                
                // Activity
                UITableView *tableView = [[UITableView alloc] init];
                tableView.frame = CGRectMake(0.0,
                                             CGRectGetMaxY(mainTitleLabel.frame) + 10.0,
                                             self.view.frame.size.width,
                                             [self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] * [self.merchant.discountArray count]);
                tableView.delegate = self;
                tableView.dataSource = self;
                tableView.backgroundColor = [UIColor clearColor];
                tableView.separatorColor = [UIColor clearColor];
                tableView.scrollEnabled = NO;
                [scrollView addSubview:tableView];
                scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                    CGRectGetMaxY(tableView.frame) + 10.0);
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

- (void)follow:(UIButton *)button
{
    if ([[Member sharedMember] isLogined]) {
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
            if (self.merchant.hasCollect) {
                Result *result = [[Member sharedMember] removeCollectMerchant:self.merchantID];
                if (result.isSuccess) {
                    self.merchant.hasCollect = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIButton *followButton = (UIButton *)[self.view viewWithTag:FOLLOW_BUTTON];
                        [followButton setTitle:@"加关注" forState:UIControlStateNormal];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            } else {
                Result *result = [[Member sharedMember] collectMerchant:self.merchantID];
                if (result.isSuccess) {
                    self.merchant.hasCollect = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIButton *followButton = (UIButton *)[self.view viewWithTag:FOLLOW_BUTTON];
                        [followButton setTitle:@"删关注" forState:UIControlStateNormal];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            }
            
        });
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [activityIndicatorView removeFromSuperview];
        });
    } else {
        MemberLoginViewController *loginVC = [[MemberLoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    }

}

- (void)productPressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    ProductListViewController *productVC = [[ProductListViewController alloc] initWithDataObject:self.merchantID];
    productVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productVC animated:YES];
}

- (void)branchPressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    MerchantBranchListViewController *branchVC = [[MerchantBranchListViewController alloc] initWithDataObject:self.merchantID];
    branchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:branchVC animated:YES];
}

- (void)informationPressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    InformationDetailViewController *informationVC = [[InformationDetailViewController alloc] init];
    informationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:informationVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Discount *discount = [self.merchant.discountArray objectAtIndex:indexPath.row];
    InformationDetailViewController *detailVC = [[InformationDetailViewController alloc] initWithDataObject:discount.discountID];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.merchant.discountArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Discount *discount = [self.merchant.discountArray objectAtIndex:indexPath.row];
    
    CalendarInformationCell *cell = [[CalendarInformationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text = discount.title;
    cell.detailTextLabel.text = [discount startEndDateString];
    return cell;
}

@end
