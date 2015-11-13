//
//  CalendaViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-7.
//
//

#import "CalendarViewController.h"
#import "CalendarInformationCell.h"
#import "InformationDetailViewController.h"
#import "CKCalendarView.h"
#import "ViewSize.h"
#import "Macros.h"
#import "Discount.h"

#define TABLE_HEADER_HEIGHT 37.0
#define TABLE_CELL_HEIGHT 65.0

@interface CalendarViewController ()<CKCalendarDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) CKCalendarView *calendar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *minimumDate;
//@property (nonatomic, strong) NSArray *disabledDates;
@property (nonatomic, strong) NSArray *enabledDates;
//@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSMutableArray *discountArray;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation CalendarViewController

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
    // Background color
    self.view.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);

    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeDidChange)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    
    
    //
//    self.selectedDate = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
    
    // Scroll view
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0.0,
                                       0.0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height);
    [self.view addSubview:self.scrollView];
    
    
    // Calendar
    self.calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar.frame = CGRectMake(15.0, 0.0, 290.0, 320.0);
    self.calendar.delegate = self;
    self.calendar.onlyShowCurrentMonth = NO;
    self.calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    self.calendar.backgroundColor = [UIColor clearColor];
    self.calendar.titleFont = [UIFont systemFontOfSize:18.0];
    self.calendar.titleColor = UIColorFromRGB(169.0, 139.0, 119.0);
    [self.scrollView addSubview:self.calendar];
    
    
    // Activity
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0.0,
                                      CGRectGetMaxY(self.calendar.frame) + 20.0,
                                      self.view.frame.size.width,
                                      TABLE_HEADER_HEIGHT + TABLE_CELL_HEIGHT * 1.0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    [self.scrollView addSubview:self.tableView];
    
    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
//                                             CGRectGetMaxY(self.tableView.frame));
    
    
 
    
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
        NSDateFormatter *dateFormatter = [self.calendar.dateFormatter copy];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        Result *result = [Discount requestCalendar:self.calendar.firstDate
                                           endDate:self.calendar.lastDate
                                     dateFormatter:dateFormatter];
        if (result.isSuccess) {
            self.enabledDates = (NSArray *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.calendar reloadData];
                [self.calendar selectDate:[NSDate date] makeVisible:YES];
                [UIView animateWithDuration:0.25 animations:^{
                    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                                             CGRectGetMaxY(self.tableView.frame));
                }];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    });
    dispatch_group_async(group, queue, ^{
        NSDateFormatter *dateFormatter = [self.calendar.dateFormatter copy];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        Result *result = [Discount requestList:[NSDate date] endDate:[NSDate date] dateFormatter:dateFormatter discountCategoryID:@-1 offset:0 limit:100];
        if (result.isSuccess) {
            self.discountArray = (NSMutableArray *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [UIView animateWithDuration:0.25 animations:^{
                    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                                      self.tableView.frame.origin.y,
                                                      self.tableView.contentSize.width,
                                                      self.tableView.contentSize.height);
                    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                                             CGRectGetMaxY(self.tableView.frame));
                }];
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


- (void)localeDidChange
{
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date
{
    BOOL isEnabled = NO;
    
    for (NSDate *enabledDate in self.enabledDates) {
        if ([enabledDate isEqualToDate:date]) {
            isEnabled = YES;
            break;
        }
    }
    return (isEnabled == NO);
}

#pragma mark -
#pragma mark - CKCalendarDelegate
- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date
{
    // TODO: play with the coloring if we want to...
    if (!calendar.onlyShowCurrentMonth && ![calendar dateIsInCurrentMonth:date]
        && ![self dateIsDisabled:date]) {
        dateItem.backgroundColor = UIColorFromRGB(237.0, 231.0, 224.0);
        dateItem.textColor = [UIColor grayColor];
    }
    if (!calendar.onlyShowCurrentMonth && ![calendar dateIsInCurrentMonth:date]
        && [self dateIsDisabled:date]) {
        dateItem.backgroundColor = UIColorFromRGB(237.0, 231.0, 224.0);
        dateItem.textColor = [UIColor lightGrayColor];
    } else if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor = [UIColor whiteColor];
        dateItem.textColor = [UIColor grayColor];
    } else if (![self dateIsDisabled:date] && [calendar date:date isSameDayAsDate:[NSDate date]]) {
        dateItem.backgroundColor = UIColorFromRGB(255.0, 228.0, 145.0);
        dateItem.textColor = [UIColor grayColor];
    } else if ([calendar date:date isSameDayAsDate:[NSDate date]]) {
        dateItem.backgroundColor = UIColorFromRGB(255.0, 228.0, 145.0);
        dateItem.textColor = [UIColor grayColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date
{
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    if (date == nil) {
        self.discountArray = [[NSMutableArray alloc] init];
        [self.tableView reloadData];
        return;
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
        NSDateFormatter *dateFormatter = [self.calendar.dateFormatter copy];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        Result *result = [Discount requestList:date endDate:date dateFormatter:dateFormatter discountCategoryID:@-1 offset:0 limit:100];
        if (result.isSuccess) {
            self.discountArray = (NSMutableArray *)result.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [UIView animateWithDuration:0.25 animations:^{
                    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                                      self.tableView.frame.origin.y,
                                                      self.tableView.contentSize.width,
                                                      self.tableView.contentSize.height);
                    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                                             CGRectGetMaxY(self.tableView.frame));
                }];
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

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date
{
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor clearColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor clearColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame
{
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0.0,
                                          CGRectGetMaxY(frame) + 20.0,
                                          self.view.frame.size.width,
                                          TABLE_HEADER_HEIGHT + TABLE_CELL_HEIGHT * 1.0);
    } completion:^(BOOL finished) {
        if (finished) {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                                     CGRectGetMaxY(self.tableView.frame));
        }
    }];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(15.0,
                                  0.0,
                                  self.view.frame.size.width - 15.0 * 2.0,
                                  TABLE_HEADER_HEIGHT);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = @"即将开始的活动";
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Discount *discount = [self.discountArray objectAtIndex:indexPath.row];
    InformationDetailViewController *detailVC = [[InformationDetailViewController alloc] initWithDataObject:discount.discountID];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.discountArray count] == 0) {
        return 1;
    }
    
    return [self.discountArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.discountArray count] == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];

        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"暂无活动信息";
        
        return cell;
    } else {
        Discount *discount = [self.discountArray objectAtIndex:indexPath.row];
        
        CalendarInformationCell *cell = [[CalendarInformationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.text = discount.title;
        cell.detailTextLabel.text = [discount startEndDateString];
        return cell;
    }
    
    return nil;
}

@end
