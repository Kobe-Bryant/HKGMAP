//
//  InformationDetailViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-6.
//
//

#import "InformationDetailViewController.h"
#import "InformationDetailGalleryViewController.h"
#import "InformationStoreListViewController.h"
#import "MemberLoginViewController.h"
#import "ViewSize.h"
#import "Macros.h"
#import "Discount.h"
#import "WebView.h"
#import "Member.h"
#import "SDWebImage/UIImageView+WebCache.h"

#define MAIN_CONTAINER 2201
#define CONTENT_CONTAINER 2202
#define CONTENT_BOTTOM 2203
#define DOWNLOAD_BUTTON 2204
#define COLLECT_BUTTON 2205

@interface InformationDetailViewController ()

@property (nonatomic, retain) NSNumber *discountID;
@property (nonatomic, retain) Discount *discount;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation InformationDetailViewController

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
        self.discountID = dataObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.autoresizesSubviews = NO;

    
    // Title
    self.title = @"优惠资讯";
    
    
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

    UIImage *shareIcon = [UIImage imageNamed:@"NavigationBarShareIcon"];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0.0,
                                   0.0,
                                   shareIcon.size.width,
                                   shareIcon.size.height);
    [shareButton setImage:shareIcon forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = shareButtonItem;
    
    
    // Background color
    self.view.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
    
    
    

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
        Result *result = [Discount requestOne:member.memberID discountID:self.discountID];
        if (result.isSuccess) {
            self.discount = result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                // Scroll view
                UIScrollView *scrollView = [[UIScrollView alloc] init];
                scrollView.frame = CGRectMake(0.0,
                                              0.0,
                                              self.view.frame.size.width,
                                              self.view.frame.size.height);
                scrollView.tag = MAIN_CONTAINER;
                [self.view addSubview:scrollView];
                
                
                // Gallery
                InformationDetailGalleryViewController *galleryVC = [[InformationDetailGalleryViewController alloc] initWithDataObject:self.discount.discountGalleryArray];
                galleryVC.view.frame = CGRectMake(0.0,
                                                  0.0,
                                                  self.view.frame.size.width,
                                                  200.0);
                galleryVC.view.hidden = ([self.discount.discountGalleryArray count] == 0);
                [self addChildViewController:galleryVC];
                [scrollView addSubview:galleryVC.view];
                
                
                // Title
                UILabel *titleLabel = [[UILabel alloc] init];
                if (galleryVC.view.hidden == YES) {
                    titleLabel.frame = CGRectMake(15.0,
                                                  20.0,
                                                  scrollView.frame.size.width - 30.0,
                                                  titleLabel.frame.size.height);
                } else {
                    titleLabel.frame = CGRectMake(15.0,
                                                  CGRectGetMaxY(galleryVC.view.frame) + 20.0,
                                                  scrollView.frame.size.width - 30.0,
                                                  titleLabel.frame.size.height);
                }
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.font = [UIFont systemFontOfSize:20.0];
                titleLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
                titleLabel.numberOfLines = 5;
                titleLabel.text = self.discount.title;
                [titleLabel sizeToFit];
                [scrollView addSubview:titleLabel];
                
                
                // Date
                UILabel *dateLabel = [[UILabel alloc] init];
                dateLabel.frame = CGRectMake(titleLabel.frame.origin.x,
                                             CGRectGetMaxY(titleLabel.frame) + 10.0,
                                             titleLabel.frame.size.width,
                                             dateLabel.frame.size.height);
                dateLabel.backgroundColor = [UIColor clearColor];
                dateLabel.font = [UIFont systemFontOfSize:11.0];
                dateLabel.textColor = [UIColor lightGrayColor];
                dateLabel.numberOfLines = 1;
                dateLabel.text = [[NSString alloc] initWithFormat:@"有效期：%@", [self.discount startEndDateString]];
                [dateLabel sizeToFit];
                [scrollView addSubview:dateLabel];
                
                
                // Join view
                UIView *joinView = [[UIView alloc] init];
                joinView.frame = CGRectMake(dateLabel.frame.origin.x,
                                            CGRectGetMaxY(dateLabel.frame) + 10.0,
                                            290.0,
                                            50.0);
                joinView.backgroundColor = [UIColor whiteColor];
                joinView.hidden = (self.discount.merchantCount.integerValue == 0);
                [scrollView addSubview:joinView];
                
                
                UILabel *joinTipsLabel = [[UILabel alloc] init];
                joinTipsLabel.frame = CGRectMake(15.0,
                                                 15.0,
                                                 120.0,
                                                 joinView.frame.size.height - [UIImage imageNamed:@"InformationFrameButtom"].size.height);
                joinTipsLabel.backgroundColor = [UIColor clearColor];
                joinTipsLabel.font = [UIFont systemFontOfSize:15.0];
                joinTipsLabel.text = @"参与此优惠商户";
                [joinTipsLabel sizeToFit];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRelatedMerchant:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [joinView addGestureRecognizer:tap];
                
                [joinView addSubview:joinTipsLabel];
                
                
                UILabel *joinQuantityLabel = [[UILabel alloc] init];
                joinQuantityLabel.backgroundColor = [UIColor clearColor];
                joinQuantityLabel.font = [UIFont boldSystemFontOfSize:15.0];
                joinQuantityLabel.textColor = UIColorFromRGB(187.0, 45.0, 26.0);
                joinQuantityLabel.text = [self.discount.merchantCount stringValue];
                [joinQuantityLabel sizeToFit];
                joinQuantityLabel.frame = CGRectMake(joinView.frame.size.width - joinQuantityLabel.frame.size.width - 35.0,
                                                     joinTipsLabel.frame.origin.y,
                                                     joinQuantityLabel.frame.size.width,
                                                     joinQuantityLabel.frame.size.height);
                [joinView addSubview:joinQuantityLabel];
                
                
                UILabel *joinUnitLabel = [[UILabel alloc] init];
                joinUnitLabel.frame = CGRectMake(CGRectGetMaxX(joinQuantityLabel.frame) + 5.0,
                                                 joinQuantityLabel.frame.origin.y,
                                                 20.0,
                                                 joinUnitLabel.frame.size.height);
                joinUnitLabel.backgroundColor = [UIColor clearColor];
                joinUnitLabel.font = [UIFont systemFontOfSize:15.0];
                joinUnitLabel.textColor = [UIColor grayColor];
                joinUnitLabel.text = @"家";
                [joinUnitLabel sizeToFit];
                [joinView addSubview:joinUnitLabel];
                
                
                UIImageView *joinButtomImageView = [[UIImageView alloc] init];
                joinButtomImageView.image = [UIImage imageNamed:@"InformationFrameButtom"];
                joinButtomImageView.frame = CGRectMake(0.0,
                                                       joinView.frame.size.height - joinButtomImageView.image.size.height,
                                                       joinButtomImageView.image.size.width,
                                                       joinButtomImageView.image.size.height);
                [joinView addSubview:joinButtomImageView];
                
                
                // Discount view
                UILabel *discountTitleLabel = [[UILabel alloc] init];
                if (joinView.hidden == YES) {
                    discountTitleLabel.frame = CGRectMake(joinView.frame.origin.x,
                                                          CGRectGetMaxY(dateLabel.frame) + 10.0,
                                                          discountTitleLabel.frame.size.width,
                                                          discountTitleLabel.frame.size.height);
                } else {
                    discountTitleLabel.frame = CGRectMake(joinView.frame.origin.x,
                                                          CGRectGetMaxY(joinView.frame) + 10.0,
                                                          discountTitleLabel.frame.size.width,
                                                          discountTitleLabel.frame.size.height);
                }
                discountTitleLabel.backgroundColor = [UIColor clearColor];
                discountTitleLabel.font = [UIFont systemFontOfSize:15.0];
                discountTitleLabel.textColor = [UIColor grayColor];
                discountTitleLabel.text = @"优惠内容";
                [discountTitleLabel sizeToFit];
                [scrollView addSubview:discountTitleLabel];
                
                
                UIView *discountView = [[UIView alloc] init];
                discountView.frame = CGRectMake(discountTitleLabel.frame.origin.x,
                                                CGRectGetMaxY(discountTitleLabel.frame) + 10.0,
                                                290.0,
                                                50.0);
                discountView.backgroundColor = [UIColor whiteColor];
                discountView.tag = CONTENT_CONTAINER;
                [scrollView addSubview:discountView];
                
                
                WebView *webView = [[WebView alloc] init];
                webView.frame = CGRectMake(5.0,
                                           5.0,
                                           discountView.frame.size.width - 10.0,
                                           100.0);
                webView.delegate = self;
                webView.scrollView.scrollEnabled = NO;
                if (self.discount.contents != nil && self.discount.contents.length > 0) {
                    [webView loadHTMLStringWithCustomStyle:self.discount.contents baseURL:nil];
                }
                [discountView addSubview:webView];
                
                
                discountView.frame = CGRectMake(discountView.frame.origin.x,
                                                discountView.frame.origin.y,
                                                discountView.frame.size.width,
                                                webView.frame.size.height + 15.0);
                
                
                UIImageView *discountButtomImageView = [[UIImageView alloc] init];
                discountButtomImageView.image = [UIImage imageNamed:@"InformationFrameButtom"];
                discountButtomImageView.frame = CGRectMake(0.0,
                                                           discountView.frame.size.height - discountButtomImageView.image.size.height,
                                                           discountButtomImageView.image.size.width,
                                                           discountButtomImageView.image.size.height);
                discountButtomImageView.tag = CONTENT_BOTTOM;
                [discountView addSubview:discountButtomImageView];
                
                
                // Download button
                UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                UIImage *downloadButtonImage = [UIImage imageNamed:@"InformationDownloadButton"];
                downloadButton.frame = CGRectMake((scrollView.frame.size.width - downloadButtonImage.size.width) / 2.0,
                                                  CGRectGetMaxY(discountView.frame) + 15.0,
                                                  downloadButtonImage.size.width,
                                                  downloadButtonImage.size.height);
                downloadButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
                [downloadButton setBackgroundImage:downloadButtonImage
                                          forState:UIControlStateNormal];
                [downloadButton setTitle:@"下载到手机" forState:UIControlStateNormal];
                [downloadButton setTitleColor:[UIColor whiteColor]
                                     forState:UIControlStateNormal];
                downloadButton.userInteractionEnabled = YES;
                downloadButton.tag = DOWNLOAD_BUTTON;
                [scrollView addSubview:downloadButton];
                
                
                // Collect button
                UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                UIImage *collectButtonImage = [UIImage imageNamed:@"InformationCollectButton"];
                collectButton.frame = CGRectMake((scrollView.frame.size.width - collectButtonImage.size.width) / 2.0,
                                                 CGRectGetMaxY(downloadButton.frame) + 10.0,
                                                 collectButtonImage.size.width,
                                                 collectButtonImage.size.height);
                collectButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
                [collectButton setBackgroundImage:collectButtonImage
                                         forState:UIControlStateNormal];
                if (self.discount.hasCollect) {
                    [collectButton setTitle:@"取消优惠收藏" forState:UIControlStateNormal];
                } else {
                    [collectButton setTitle:@"收藏此优惠" forState:UIControlStateNormal];
                }
                
                [collectButton setTitleColor:[UIColor grayColor]
                                    forState:UIControlStateNormal];
                collectButton.userInteractionEnabled = YES;
                collectButton.tag = COLLECT_BUTTON;
                [collectButton addTarget:self
                                  action:@selector(collect:)
                        forControlEvents:UIControlEventTouchDown];
                [scrollView addSubview:collectButton];
                
                
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                                    CGRectGetMaxY(collectButton.frame) + 15.0);

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

- (void)share:(UIButton *)button
{
    if (self.discount != nil) {
        NSMutableArray *activityItems = [[NSMutableArray alloc] init];
        if (self.discount.title != nil) {
            [activityItems addObject:self.discount.title];
        }
        if (self.discount.contents != nil) {
            [activityItems addObject:self.discount.title];
        }
        if (self.discount.imageURLString != nil) {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.discount.imageURLString];
            if (image != nil) {
                [activityItems addObject:image];
            }
        }
        NSMutableArray *applicationActivities = [[NSMutableArray alloc] init];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems:activityItems
                                                applicationActivities:applicationActivities];
        activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                             UIActivityTypePostToWeibo,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeCopyToPasteboard,
                                             UIActivityTypePrint];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

- (void)tapRelatedMerchant:(UIGestureRecognizer *)gestureRecognizer
{
    InformationStoreListViewController *merchantVC = [[InformationStoreListViewController alloc] initWithDataObject:self.discountID];
    [self.navigationController pushViewController:merchantVC animated:YES];
}

- (void)collect:(UIButton *)button
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
            if (self.discount.hasCollect) {
                Result *result = [[Member sharedMember] removeCollectDiscount:self.discountID];
                if (result.isSuccess) {
                    self.discount.hasCollect = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIButton *collectButton = (UIButton *)[self.view viewWithTag:COLLECT_BUTTON];
                        [collectButton setTitle:@"优惠此收藏" forState:UIControlStateNormal];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            } else {
                Result *result = [[Member sharedMember] collectDiscount:self.discountID];
                if (result.isSuccess) {
                    self.discount.hasCollect = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIButton *collectButton = (UIButton *)[self.view viewWithTag:COLLECT_BUTTON];
                        [collectButton setTitle:@"取消优惠收藏" forState:UIControlStateNormal];
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

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.frame = CGRectMake(webView.frame.origin.x,
                               webView.frame.origin.y,
                               webView.frame.size.width,
                               webView.scrollView.contentSize.height);
    
    UIView *discountView = [self.view viewWithTag:CONTENT_CONTAINER];
    discountView.frame = CGRectMake(discountView.frame.origin.x,
                                    discountView.frame.origin.y,
                                    discountView.frame.size.width,
                                    webView.frame.size.height + 15.0);
    
    UIImageView *discountButtomImageView = (UIImageView *)[self.view viewWithTag:CONTENT_BOTTOM];
    discountButtomImageView.frame = CGRectMake(discountButtomImageView.frame.origin.x,
                                               discountView.frame.size.height - discountButtomImageView.image.size.height,
                                               discountButtomImageView.frame.size.width,
                                               discountButtomImageView.frame.size.height);

    UIButton *downloadButton = (UIButton *)[self.view viewWithTag:DOWNLOAD_BUTTON];
    downloadButton.frame = CGRectMake(downloadButton.frame.origin.x,
                                      CGRectGetMaxY(discountView.frame) + 15.0,
                                      downloadButton.frame.size.width,
                                      downloadButton.frame.size.height);
    
    UIButton *collectButton = (UIButton *)[self.view viewWithTag:COLLECT_BUTTON];
    collectButton.frame = CGRectMake(collectButton.frame.origin.x,
                                     CGRectGetMaxY(downloadButton.frame) + 10.0,
                                     collectButton.frame.size.width,
                                     collectButton.frame.size.height);
    
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:MAIN_CONTAINER];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                        CGRectGetMaxY(collectButton.frame) + 15.0);
}

@end
