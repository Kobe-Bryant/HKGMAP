//
//  MerchantMapFilterViewController.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-8.
//
//

#import "MerchantFilterViewController.h"
#import "ViewSize.h"
#import "Macros.h"
#import "BusinessDistrict.h"
#import "MerchantType.h"

//#define kTitleFontColor [UIColor colorWithRed:(85.0/255.0) green:(85.0/255.0) blue:(85.0/255.0) alpha:1.0]
//#define kLineColor [UIColor colorWithRed:(232.0/255.0) green:(232.0/255.0) blue:(232.0/255.0) alpha:1.0]
//#define kOptionFontColor [UIColor colorWithRed:(136.0/255.0) green:(136.0/255.0) blue:(136.0/255.0) alpha:1.0]
//#define kItemSelectedBackgroundColor [UIColor colorWithRed:(238.0/255.0) green:(238.0/255.0) blue:(238.0/255.0) alpha:1.0]

#define kRangeViewTag 4111
#define kRangeArrowTag 4112
#define kRangeTitleTag 4113
#define kRangeOptionTag 4114

#define kAreaItemX 24.0
#define kAreaItemY 26.0
#define kAreaItemWidth 60.0
#define kAreaItemHeight 35.0
//#define kAreaItemBackgroundColor [UIColor colorWithRed:(238.0/255.0) green:(238.0/255.0) blue:(238.0/255.0) alpha:1.0]
//#define kAreaItemSelectedBackgroundColor [UIColor colorWithRed:(216.0/255.0) green:(117.0/255.0) blue:(30.0/255.0) alpha:1.0]
#define kAreaViewTag 4115
#define kAreaArrowTag 4116
#define kAreaTitleTag 4117
#define kAreaOptionTag 4118

#define kTypeViewTag 4119
#define kTypeArrowTag 4120
#define kTypeTitleTag 4121
#define kTypeOptionTag 4122

@interface MerchantFilterViewController ()

@property (nonatomic, retain) NSArray *businessDistrictArray;
@property (nonatomic, retain) NSArray *merchantTypeArray;
@property (nonatomic, retain) UIView *maskView;
@property (nonatomic, retain) NSMutableArray *rangeOptionArray;
@property (nonatomic, retain) NSMutableArray *areaOptionArray;
@property (nonatomic, retain) NSMutableArray *typeOptionArray;
@property (nonatomic, readwrite) BOOL isViewWillAppeared;

@end

@implementation MerchantFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDataObject:(NSArray *)businessDistrictArray merchantTypeArray:(NSArray *)merchantTypeArray
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.businessDistrictArray = businessDistrictArray;
        self.merchantTypeArray = merchantTypeArray;
    }
    return self;}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.layer.masksToBounds = YES;
//    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
    
    // Mask
    self.maskView = [[UIView alloc] init];
    self.maskView.frame = CGRectMake(0.0,
                                     0.0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
    NSLog(@"%@",NSStringFromCGRect(self.maskView.frame));
    
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.0;
    self.maskView.hidden = YES;
    self.maskView.userInteractionEnabled = YES;
    [self.view addSubview:self.maskView];
    
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskPressed:)];
    maskTap.numberOfTapsRequired = 1;
    maskTap.numberOfTouchesRequired = 1;
    [self.maskView addGestureRecognizer:maskTap];
    
    
    // Category
    UIView *categoryView = [[UIView alloc] init];
    categoryView.frame = CGRectMake(0.0,
                                    0.0,
                                    self.view.frame.size.width,
                                    NAVIGATION_BAR_HEIGHT);
    categoryView.backgroundColor = [UIColor whiteColor];
    categoryView.layer.zPosition = 4111.0;
    [self.view addSubview:categoryView];
    
    
    CGFloat width = self.view.frame.size.width / 3.0;
    UIImage *downArrowImage = [UIImage imageNamed:@"MapFilterDownArrow"];
    
    
    // Range
    UIView *rangeView = [[UIView alloc] init];
    rangeView.frame = CGRectMake(0.0, 0.0, width, categoryView.frame.size.height);
    rangeView.backgroundColor = [UIColor whiteColor];
    rangeView.userInteractionEnabled = YES;
    rangeView.tag = kRangeViewTag;
    [categoryView addSubview:rangeView];
    
    UILabel *rangeTitleLabel = [[UILabel alloc] init];
    rangeTitleLabel.frame = CGRectMake(16.0,
                                       0.0,
                                       rangeView.frame.size.width,
                                       rangeView.frame.size.height);
    rangeTitleLabel.backgroundColor = [UIColor clearColor];
    rangeTitleLabel.textColor = UIColorFromRGB(85.0, 85.0, 85.0);
    rangeTitleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    rangeTitleLabel.text = @"选择范围";
    rangeTitleLabel.tag = kRangeTitleTag;
    [rangeView addSubview:rangeTitleLabel];
    
    UIImageView *rangeImageView = [[UIImageView alloc] initWithImage:downArrowImage];
    rangeImageView.center = CGPointMake(rangeView.frame.size.width * 0.79,
                                        rangeView.center.y);
    rangeImageView.tag = kRangeArrowTag;
    [rangeView addSubview:rangeImageView];
    
    UITapGestureRecognizer *rangeSelectorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rangeSelectorPressed:)];
    rangeSelectorTap.numberOfTapsRequired = 1;
    rangeSelectorTap.numberOfTouchesRequired = 1;
    [rangeView addGestureRecognizer:rangeSelectorTap];
    
    // Trading area
    UIView *areaView = [[UIView alloc] init];
    areaView.frame = CGRectMake(width, 0.0, width, categoryView.frame.size.height);
    areaView.backgroundColor = [UIColor whiteColor];
    areaView.userInteractionEnabled = YES;
    areaView.tag = kAreaViewTag;
    [categoryView addSubview:areaView];
    
    
    UILabel *areaTitleLabel = [[UILabel alloc] init];
    areaTitleLabel.frame = CGRectMake(16.0,
                                      0.0,
                                      areaView.frame.size.width,
                                      areaView.frame.size.height);
    areaTitleLabel.backgroundColor = [UIColor clearColor];
    areaTitleLabel.textColor = UIColorFromRGB(85.0, 85.0, 85.0);
    areaTitleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    areaTitleLabel.text = @"选择商圈";
    areaTitleLabel.tag = kAreaTitleTag;
    [areaView addSubview:areaTitleLabel];
    
    UIImageView *areaImageView = [[UIImageView alloc] initWithImage:downArrowImage];
    areaImageView.center = CGPointMake(areaView.frame.size.width * 0.79,
                                       areaView.center.y);
    areaImageView.tag = kAreaArrowTag;
    [areaView addSubview:areaImageView];
    
    UITapGestureRecognizer *areaSelectorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaSelectorPressed:)];
    areaSelectorTap.numberOfTapsRequired = 1;
    areaSelectorTap.numberOfTouchesRequired = 1;
    [areaView addGestureRecognizer:areaSelectorTap];
    
    // Merchant type
    UIView *typeView = [[UIView alloc] init];
    typeView.frame = CGRectMake(width * 2.0, 0.0, width, categoryView.frame.size.height);
    typeView.backgroundColor = [UIColor whiteColor];
    typeView.userInteractionEnabled = YES;
    typeView.tag = kTypeViewTag;
    [categoryView addSubview:typeView];
    
    UILabel *typeTitleLabel = [[UILabel alloc] init];
    typeTitleLabel.frame = CGRectMake(16.0,
                                      0.0,
                                      typeView.frame.size.width,
                                      typeView.frame.size.height);
    typeTitleLabel.backgroundColor = [UIColor clearColor];
    typeTitleLabel.textColor = UIColorFromRGB(85.0, 85.0, 85.0);
    typeTitleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    typeTitleLabel.text = @"商户类型";
    typeTitleLabel.tag = kTypeTitleTag;
    [typeView addSubview:typeTitleLabel];
    
    UIImageView *typeImageView = [[UIImageView alloc] initWithImage:downArrowImage];
    typeImageView.center = CGPointMake(typeView.frame.size.width * 0.79,
                                       typeView.center.y);
    typeImageView.tag = kTypeArrowTag;
    [typeView addSubview:typeImageView];
    
    UITapGestureRecognizer *typeSelectorTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(typeSelectorPressed:)];
    typeSelectorTap.numberOfTapsRequired = 1;
    typeSelectorTap.numberOfTouchesRequired = 1;
    [typeView addGestureRecognizer:typeSelectorTap];
    
    // Seperate line
    for (NSUInteger i = 1; i < 3; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(width * i, 0.0, 1.0, NAVIGATION_BAR_HEIGHT);
        lineView.backgroundColor = UIColorFromRGB(232.0, 232.0, 232.0);
        [categoryView addSubview:lineView];
    }
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.frame = CGRectMake(0.0,
                                      NAVIGATION_BAR_HEIGHT - 1.0,
                                      self.view.frame.size.width,
                                      1.0);
    bottomLineView.backgroundColor = UIColorFromRGB(232, 232.0, 232.0);
    [categoryView addSubview:bottomLineView];
    
    
    // Range option
    self.rangeOptionArray = [[NSMutableArray alloc] initWithObjects:@"所有范围", @"100 米", @"300 米", @"500 米", @"1,000 米", @"2,000 米", nil];
    
    UIView *rangeOptionsView = [[UIView alloc] init];
    rangeOptionsView.frame = CGRectMake(0.0,
                                        NAVIGATION_BAR_HEIGHT,
                                        self.view.frame.size.width,
                                        NAVIGATION_BAR_HEIGHT * [self.rangeOptionArray count] + 10.0);
    rangeOptionsView.tag = kRangeOptionTag;
    rangeOptionsView.hidden = YES;
    [self.view addSubview:rangeOptionsView];
    
    for (NSUInteger i = 0; i < [self.rangeOptionArray count]; i++) {
        UIView *rangeOptionView = [[UIView alloc] init];
        rangeOptionView.frame = CGRectMake(0.0,
                                           NAVIGATION_BAR_HEIGHT * i,
                                           rangeOptionsView.frame.size.width,
                                           NAVIGATION_BAR_HEIGHT);
        if (i == 0) {
            rangeOptionView.backgroundColor = UIColorFromRGB(238.0, 238.0, 238.0);
        } else {
            rangeOptionView.backgroundColor = [UIColor whiteColor];
        }
        rangeOptionView.layer.zPosition = 4112.0;
        rangeOptionView.tag = i;
        [rangeOptionsView addSubview:rangeOptionView];
        
        UILabel *rangeLabel = [[UILabel alloc] init];
        rangeLabel.frame = CGRectMake(15.0,
                                      0.0,
                                      rangeOptionView.frame.size.width,
                                      rangeOptionView.frame.size.height);
        rangeLabel.backgroundColor = [UIColor clearColor];
        rangeLabel.textColor = UIColorFromRGB(136.0, 136.0, 136.0);
        rangeLabel.font = [UIFont systemFontOfSize:13.0];
        rangeLabel.text = [self.rangeOptionArray objectAtIndex:i];
        [rangeOptionView addSubview:rangeLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(rangeOptionView.frame.origin.x,
                                    rangeOptionView.frame.size.height - 1.0,
                                    rangeOptionView.frame.size.width,
                                    1.0);
        lineView.backgroundColor = UIColorFromRGB(232.0, 232.0, 232.0);
        [rangeOptionView addSubview:lineView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rangeOptionPressed:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [rangeOptionView addGestureRecognizer:tapGestureRecognizer];
    }
    
    UIView *rangeButtomView = [[UIView alloc] init];
    rangeButtomView.frame = CGRectMake(0.0,
                                       rangeOptionsView.frame.size.height - 20.0,
                                       rangeOptionsView.frame.size.width,
                                       20.0);
    rangeButtomView.backgroundColor = [UIColor whiteColor];
    rangeButtomView.layer.cornerRadius = 5.0;
    [rangeOptionsView addSubview:rangeButtomView];
    
    
    
    // Trading area option
    BusinessDistrict *allBusinessDistrict = [[BusinessDistrict alloc] init];
    allBusinessDistrict.businessDistrictID = @-1;
    allBusinessDistrict.name = @"所有范围";
    
    self.areaOptionArray = [[NSMutableArray alloc] initWithObjects:allBusinessDistrict, nil];
    [self.areaOptionArray addObjectsFromArray:self.businessDistrictArray];
    
    CGFloat separateWidth = (self.view.frame.size.width - kAreaItemX * 2.0 - kAreaItemWidth * 4.0) / 3.0;
    
    UIView *areaOptionsView = [[UIView alloc] init];
    areaOptionsView.frame = CGRectMake(0.0,
                                       NAVIGATION_BAR_HEIGHT,
                                       self.view.frame.size.width,
                                       kAreaItemY * 2.0 + (separateWidth + kAreaItemHeight) * ceil([self.areaOptionArray count] / 4.0) - 10.0);
    areaOptionsView.hidden = YES;
    areaOptionsView.tag = kAreaOptionTag;
    [self.view addSubview:areaOptionsView];
    
    UIView *areaButtomView = [[UIView alloc] init];
    areaButtomView.frame = CGRectMake(0.0,
                                      areaOptionsView.frame.size.height - 20.0,
                                      areaOptionsView.frame.size.width,
                                      20.0);
    areaButtomView.backgroundColor = [UIColor whiteColor];
    areaButtomView.layer.cornerRadius = 5.0;
    [areaOptionsView addSubview:areaButtomView];
    
    UIView *areaMainView = [[UIView alloc] init];
    areaMainView.frame = CGRectMake(0.0,
                                    0.0,
                                    areaOptionsView.frame.size.width,
                                    areaOptionsView.frame.size.height - 10.0);
    areaMainView.backgroundColor = [UIColor whiteColor];
    [areaOptionsView addSubview:areaMainView];
    
    for (NSUInteger i = 0; i < [self.areaOptionArray count]; i++) {
        BusinessDistrict *businessDistrict = [self.areaOptionArray objectAtIndex:i];
        
        NSUInteger row = floor(i / 4.0);
        CGFloat x = kAreaItemX + (separateWidth + kAreaItemWidth) * (i % 4);
        CGFloat y = kAreaItemY + (separateWidth + kAreaItemHeight) * row;
        
        UIButton *areaOptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        areaOptionButton.frame = CGRectMake(x, y, kAreaItemWidth, kAreaItemHeight);
        if (i == 0) {
            areaOptionButton.backgroundColor = UIColorFromRGB(216.0, 117.0, 30.0);
        } else {
            areaOptionButton.backgroundColor = UIColorFromRGB(238.0, 238.0, 238.0);
        }
        areaOptionButton.layer.cornerRadius = 2.0;
        areaOptionButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [areaOptionButton setTitle:businessDistrict.name
                          forState:UIControlStateNormal];
        [areaOptionButton setTitleColor:UIColorFromRGB(136.0, 136.0, 136.0)
                               forState:UIControlStateNormal];
        [areaOptionButton setTitleColor:[UIColor whiteColor]
                               forState:UIControlStateSelected];
        [areaOptionButton addTarget:self
                             action:@selector(areaOptionPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
        areaOptionButton.tag = i;
        [areaMainView addSubview:areaOptionButton];
        
        if (i == 0) {
            [areaOptionButton setSelected:YES];
        }
    }
    
    
    // Merchant type option
    MerchantType *allMerchantType = [[MerchantType alloc] init];
    allMerchantType.merchantTypeID = @-1;
    allMerchantType.name = @"所有商户";
    
    self.typeOptionArray = [[NSMutableArray alloc] initWithObjects:allMerchantType, nil];
    [self.typeOptionArray addObjectsFromArray:self.merchantTypeArray];
    
    UIView *typeOptionsView = [[UIView alloc] init];
    typeOptionsView.frame = CGRectMake(0.0,
                                       NAVIGATION_BAR_HEIGHT,
                                       self.view.frame.size.width,
                                       NAVIGATION_BAR_HEIGHT * [self.typeOptionArray count] + 10.0);
    typeOptionsView.hidden = YES;
    typeOptionsView.tag = kTypeOptionTag;
    [self.view addSubview:typeOptionsView];
    
    
    for (NSUInteger i = 0; i < [self.typeOptionArray count]; i++) {
        MerchantType *merchantType = [self.typeOptionArray objectAtIndex:i];
        
        UIView *typeOptionView = [[UIView alloc] init];
        typeOptionView.frame = CGRectMake(0.0,
                                          NAVIGATION_BAR_HEIGHT * i,
                                          typeOptionsView.frame.size.width,
                                          NAVIGATION_BAR_HEIGHT);
        if (i == 0) {
            typeOptionView.backgroundColor = UIColorFromRGB(238.0, 238.0, 238.0);
        } else {
            typeOptionView.backgroundColor = [UIColor whiteColor];
        }
        typeOptionView.layer.zPosition = 4113.0;
        typeOptionView.tag = i;
        [typeOptionsView addSubview:typeOptionView];
        
        UILabel *typeLabel = [[UILabel alloc] init];
        typeLabel.frame = CGRectMake(15.0,
                                     0.0,
                                     typeOptionView.frame.size.width,
                                     typeOptionView.frame.size.height);
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel.textColor = UIColorFromRGB(136.0, 136.0, 136.0);
        typeLabel.font = [UIFont systemFontOfSize:13.0];
        typeLabel.text = merchantType.name;
        [typeOptionView addSubview:typeLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(typeOptionView.frame.origin.x,
                                    typeOptionView.frame.size.height - 1.0,
                                    typeOptionView.frame.size.width,
                                    1.0);
        lineView.backgroundColor = UIColorFromRGB(232.0, 232.0, 232.0);
        [typeOptionView addSubview:lineView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeOptionPressed:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [typeOptionView addGestureRecognizer:tapGestureRecognizer];
    }
    
    
    UIView *typeButtomView = [[UIView alloc] init];
    typeButtomView.frame = CGRectMake(0.0,
                                      typeOptionsView.frame.size.height - 20.0,
                                      typeOptionsView.frame.size.width,
                                      20.0);
    typeButtomView.backgroundColor = [UIColor whiteColor];
    typeButtomView.layer.cornerRadius = 5.0;
    [typeOptionsView addSubview:typeButtomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMask
{
    [self.delegate showFilterSubmenu];
    
    self.maskView.frame = CGRectMake(0.0,
                                     0.0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.hidden = NO;
        self.maskView.alpha = 0.7;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideMask
{
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.maskView.hidden = YES;
            [self.delegate hideFilterSubmenu];
        }
    }];
}

- (void)showRangeSelector
{
    [self showMask];
    
    UIView *arrowView = [self.view viewWithTag:kRangeArrowTag];
    UIView *rangeOptionView = [self.view viewWithTag:kRangeOptionTag];
    
    if (rangeOptionView.hidden) {
        rangeOptionView.frame = CGRectMake(rangeOptionView.frame.origin.x,
                                           NAVIGATION_BAR_HEIGHT - rangeOptionView.frame.size.height,
                                           rangeOptionView.frame.size.width,
                                           rangeOptionView.frame.size.height);
        rangeOptionView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, M_PI, 0.0, 0.0, 1.0);
            arrowView.layer.transform = transform;
            
            rangeOptionView.frame = CGRectMake(rangeOptionView.frame.origin.x,
                                               NAVIGATION_BAR_HEIGHT,
                                               rangeOptionView.frame.size.width,
                                               rangeOptionView.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)hideRangeSelector:(void(^)(void))callbackBlock
{
    UIView *rangeView = [self.view viewWithTag:kRangeViewTag];
    UIView *arrowView = [self.view viewWithTag:kRangeArrowTag];
    UIView *rangeOptionView = [self.view viewWithTag:kRangeOptionTag];
    
    if (!rangeOptionView.hidden) {
        rangeView.backgroundColor = [UIColor whiteColor];
        
        [UIView animateWithDuration:0.25 animations:^{
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, M_PI * 2.0, 0.0, 0.0, 1.0);
            arrowView.layer.transform = transform;
            
            rangeOptionView.frame = CGRectMake(rangeOptionView.frame.origin.x,
                                               NAVIGATION_BAR_HEIGHT - rangeOptionView.frame.size.height,
                                               rangeOptionView.frame.size.width,
                                               rangeOptionView.frame.size.height);
        } completion:^(BOOL finished) {
            rangeOptionView.hidden = YES;
            
            if (callbackBlock != nil) {
                callbackBlock();
            }
        }];
        
        if (callbackBlock == nil) {
            [self hideMask];
        }
    }
}

- (void)rangeSelectorPressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIView *rangeView = [self.view viewWithTag:kRangeViewTag];
    rangeView.backgroundColor = UIColorFromRGB(238.0, 238.0, 238.0);
    
    UIView *rangeOptionView = [self.view viewWithTag:kRangeOptionTag];
    UIView *areaOptionView = [self.view viewWithTag:kAreaOptionTag];
    UIView *typeOptionView = [self.view viewWithTag:kTypeOptionTag];
    if (rangeOptionView.hidden) {
        if (!areaOptionView.hidden) {
            [self hideAreaSelector:^{
                [self showRangeSelector];
            }];
        } else if (!typeOptionView.hidden) {
            [self hideTypeSelector:^{
                [self showRangeSelector];
            }];
        } else {
            [self showRangeSelector];
        }
    } else {
        [self hideRangeSelector:nil];
    }
}

- (void)showAreaSelector
{
    [self showMask];
    
    UIView *arrowView = [self.view viewWithTag:kAreaArrowTag];
    UIView *areaOptionView = [self.view viewWithTag:kAreaOptionTag];
    if (areaOptionView.hidden) {
        areaOptionView.frame = CGRectMake(areaOptionView.frame.origin.x,
                                          NAVIGATION_BAR_HEIGHT - areaOptionView.frame.size.height,
                                          areaOptionView.frame.size.width,
                                          areaOptionView.frame.size.height);
        areaOptionView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, M_PI, 0.0, 0.0, 1.0);
            arrowView.layer.transform = transform;
            
            areaOptionView.frame = CGRectMake(areaOptionView.frame.origin.x,
                                              NAVIGATION_BAR_HEIGHT,
                                              areaOptionView.frame.size.width,
                                              areaOptionView.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)hideAreaSelector:(void(^)(void))callbackBlock
{
    UIView *areaView = [self.view viewWithTag:kAreaViewTag];
    UIView *arrowView = [self.view viewWithTag:kAreaArrowTag];
    UIView *areaOptionView = [self.view viewWithTag:kAreaOptionTag];
    if (!areaOptionView.hidden) {
        areaView.backgroundColor = [UIColor whiteColor];
        
        [UIView animateWithDuration:0.25 animations:^{
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, M_PI * 2.0, 0.0, 0.0, 1.0);
            arrowView.layer.transform = transform;
            
            areaOptionView.frame = CGRectMake(areaOptionView.frame.origin.x,
                                              NAVIGATION_BAR_HEIGHT - areaOptionView.frame.size.height,
                                              areaOptionView.frame.size.width,
                                              areaOptionView.frame.size.height);
        } completion:^(BOOL finished) {
            areaOptionView.hidden = YES;
            
            if (callbackBlock != nil) {
                callbackBlock();
            }
        }];
        
        
        if (callbackBlock == nil) {
            [self hideMask];
        }
    }
}

- (void)areaSelectorPressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIView *areaView = [self.view viewWithTag:kAreaViewTag];
    areaView.backgroundColor = UIColorFromRGB(238.0, 238.0, 238.0);

    UIView *rangeOptionView = [self.view viewWithTag:kRangeOptionTag];
    UIView *areaOptionView = [self.view viewWithTag:kAreaOptionTag];
    UIView *typeOptionView = [self.view viewWithTag:kTypeOptionTag];
    
    if (areaOptionView.hidden) {
        if (!rangeOptionView.hidden) {
            [self hideRangeSelector:^{
                [self showAreaSelector];
            }];
        } else if (!typeOptionView.hidden) {
            if (!typeOptionView.hidden) {
                [self hideTypeSelector:^{
                    [self showAreaSelector];
                }];
            }
        } else {
            [self showAreaSelector];
        }
    } else {
        [self hideAreaSelector:nil];
    }
}

- (void)showTypeSelector
{
    [self showMask];
    
    UIView *arrowView = [self.view viewWithTag:kTypeArrowTag];
    UIView *typeOptionView = [self.view viewWithTag:kTypeOptionTag];
    if (typeOptionView.hidden) {
        typeOptionView.frame = CGRectMake(typeOptionView.frame.origin.x,
                                          NAVIGATION_BAR_HEIGHT - typeOptionView.frame.size.height,
                                          typeOptionView.frame.size.width,
                                          typeOptionView.frame.size.height);
        typeOptionView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, M_PI, 0.0, 0.0, 1.0);
            arrowView.layer.transform = transform;
            
            typeOptionView.frame = CGRectMake(typeOptionView.frame.origin.x,
                                              NAVIGATION_BAR_HEIGHT,
                                              typeOptionView.frame.size.width,
                                              typeOptionView.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)hideTypeSelector:(void(^)(void))callbackBlock
{
    UIView *typeView = [self.view viewWithTag:kTypeViewTag];
    UIView *arrowView = [self.view viewWithTag:kTypeArrowTag];
    UIView *typeOptionView = [self.view viewWithTag:kTypeOptionTag];
    if (!typeOptionView.hidden) {
        typeView.backgroundColor = [UIColor whiteColor];
        
        [UIView animateWithDuration:0.25 animations:^{
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, M_PI * 2.0, 0.0, 0.0, 1.0);
            arrowView.layer.transform = transform;
            
            typeOptionView.frame = CGRectMake(typeOptionView.frame.origin.x,
                                              NAVIGATION_BAR_HEIGHT - typeOptionView.frame.size.height,
                                              typeOptionView.frame.size.width,
                                              typeOptionView.frame.size.height);
        } completion:^(BOOL finished) {
            typeOptionView.hidden = YES;
            
            if (callbackBlock != nil) {
                callbackBlock();
            }
        }];
        
        if (callbackBlock == nil) {
            [self hideMask];
        }
    }
}

- (void)typeSelectorPressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIView *typeView = [self.view viewWithTag:kTypeViewTag];
    typeView.backgroundColor = UIColorFromRGB(238.0, 238.0, 238.0);

    UIView *rangeOptionView = [self.view viewWithTag:kRangeOptionTag];
    UIView *areaOptionView = [self.view viewWithTag:kAreaOptionTag];
    UIView *typeOptionView = [self.view viewWithTag:kTypeOptionTag];
    if (typeOptionView.hidden) {
        if (!rangeOptionView.hidden) {
            [self hideRangeSelector:^{
                [self showTypeSelector];
            }];
        } else if (!areaOptionView.hidden) {
            [self hideAreaSelector:^{
                [self showTypeSelector];
            }];
        } else {
            [self showTypeSelector];
        }
    } else {
        [self hideTypeSelector:nil];
    }
    
    
}

- (void)rangeOptionPressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIView *rangeOptionsView = [self.view viewWithTag:kRangeOptionTag];
    UIView *rangeOptionView = tapGestureRecognizer.view;
    NSUInteger selectedIndex = [rangeOptionsView.subviews indexOfObject:rangeOptionView];
    for (NSUInteger i = 0; i < [rangeOptionsView.subviews count]; i++) {
        UIView *subview = [rangeOptionsView.subviews objectAtIndex:i];
        if (i == selectedIndex) {
            subview.backgroundColor = UIColorFromRGB(238.0, 238.0, 238.0);
            
            UILabel *titleLabel = (UILabel *)[self.view viewWithTag:kRangeTitleTag];
            titleLabel.text = [self.rangeOptionArray objectAtIndex:i];
        } else {
            subview.backgroundColor = [UIColor whiteColor];
        }
    }
    
    [self hideRangeSelector:nil];
    
    CGFloat nearbyRadius = 0.0;
    switch (tapGestureRecognizer.view.tag) {
        case 1:
            nearbyRadius = 100.0;
            break;
        case 2:
            nearbyRadius = 300.0;
            break;
        case 3:
            nearbyRadius = 500.0;
            break;
        case 4:
            nearbyRadius = 1000.0;
            break;
        case 5:
            nearbyRadius = 2000.0;
            break;
    }
    
    [self.delegate didSelectNearbyRadius:nearbyRadius];
}

- (void)areaOptionPressed:(UIButton *)button
{
    UIView *areaOptionView = [self.view viewWithTag:kAreaOptionTag];
    UIView *mainView = [areaOptionView.subviews objectAtIndex:1];
    
    for (NSUInteger i = 0; i < [mainView.subviews count]; i++) {
        UIButton *currentButton = [mainView.subviews objectAtIndex:i];
        if (i == button.tag) {
            [currentButton setSelected:YES];
            currentButton.backgroundColor = UIColorFromRGB(216.0, 117.0, 30.0);

            BusinessDistrict *businessDistrict = [self.areaOptionArray objectAtIndex:i];
            UILabel *titleLabel = (UILabel *)[self.view viewWithTag:kAreaTitleTag];
            titleLabel.text = businessDistrict.name;
        } else {
            [currentButton setSelected:NO];
            currentButton.backgroundColor = UIColorFromRGB(238.0, 238.0, 238.0);
        }
    }
    
    [self hideAreaSelector:nil];
    
    if (button.tag > 0) {
        BusinessDistrict *selectedBusinessDistrict = [self.businessDistrictArray objectAtIndex:(button.tag - 1)];
        [self.delegate didSelectBusinessDistrictID:selectedBusinessDistrict.businessDistrictID];
    } else {
        [self.delegate didSelectBusinessDistrictID:@-1];
    }
}

- (void)typeOptionPressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIView *typeOptionsView = [self.view viewWithTag:kTypeOptionTag];
    NSUInteger selectedIndex = [typeOptionsView.subviews indexOfObject:tapGestureRecognizer.view];
    for (NSUInteger i = 0; i < [typeOptionsView.subviews count]; i++) {
        UIView *subview = [typeOptionsView.subviews objectAtIndex:i];
        if (i == selectedIndex) {
            subview.backgroundColor = UIColorFromRGB(238.0, 238.0, 238.0);
            
            MerchantType *merchantType = [self.typeOptionArray objectAtIndex:selectedIndex];
            UILabel *titleLabel = (UILabel *)[self.view viewWithTag:kTypeTitleTag];
            titleLabel.text = merchantType.name;
        } else {
            subview.backgroundColor = [UIColor whiteColor];
        }
    }
    
    [self hideTypeSelector:nil];
        
    if (selectedIndex > 0) {
        MerchantType *selectedMerchantType = [self.merchantTypeArray objectAtIndex:(selectedIndex - 1)];
        [self.delegate didSelectMerchantTypeID:selectedMerchantType.merchantTypeID];
    } else {
        [self.delegate didSelectMerchantTypeID:@-1];
    }
}

- (void)maskPressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIView *rangeOptionView = [self.view viewWithTag:kRangeOptionTag];
    UIView *areaOptionView = [self.view viewWithTag:kAreaOptionTag];
    UIView *typeOptionView = [self.view viewWithTag:kTypeOptionTag];
    if (!rangeOptionView.hidden) {
        [self hideRangeSelector:nil];
    } else if (!areaOptionView.hidden) {
        [self hideAreaSelector:nil];
    } else if (!typeOptionView.hidden) {
        [self hideTypeSelector:nil];
    }
}

@end
