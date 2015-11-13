//
//  InformationListMenuView.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-20.
//
//

#import "InformationListMenuView.h"
#import "ViewSize.h"
#import "Macros.h"
#import "DiscountCategory.h"

//#define kScrollViewTag 2012
#define SELECTED_IMAGE_VIEW 2013

@interface InformationListMenuView ()

@property (nonatomic, retain) NSArray *discountCategoryArray;
@property (nonatomic, readwrite) BOOL isDecelerating;
@property (nonatomic, readwrite) NSUInteger selectedIndex;

@end

@implementation InformationListMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithDataObject:(id)dataObject
{
    self = [super init];
    if (self) {
        self.discountCategoryArray = dataObject;
        
        NSMutableArray *allDiscountCategoryArray = [[NSMutableArray alloc] init];
        DiscountCategory *allDiscountCategory = [[DiscountCategory alloc] init];
        allDiscountCategory.discountCategoryID = @-1;
        allDiscountCategory.title = @"所有资讯";
        [allDiscountCategoryArray addObject:allDiscountCategory];
        [allDiscountCategoryArray addObjectsFromArray:self.discountCategoryArray];

        
        CGFloat width = VIEW_WIDTH / 4.0;
        self.frame = CGRectMake(0.0,
                                0.0,
                                VIEW_WIDTH,
                                NAVIGATION_BAR_HEIGHT);
        self.contentSize = CGSizeMake(self.frame.size.width / 4.0 * ([self.discountCategoryArray count] + 1) + 10.0 * 2.0,
                                      self.frame.size.height);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        
        UIImageView *selectedImageView = [[UIImageView alloc] init];
        selectedImageView.image = [UIImage imageNamed:@"InformationMenuSelected"];
        selectedImageView.frame = CGRectMake(10.0,
                                             0.0,
                                             VIEW_WIDTH / 4.0,
                                             selectedImageView.image.size.height);
        selectedImageView.tag = SELECTED_IMAGE_VIEW;
        [self addSubview:selectedImageView];
        
        
        for (NSUInteger i = 0; i < [allDiscountCategoryArray count]; i++) {
            DiscountCategory *discountCategory = [allDiscountCategoryArray objectAtIndex:i];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.frame = CGRectMake(width * i + 10.0,
                                          0.0,
                                          width,
                                          selectedImageView.image.size.height);
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = discountCategory.title;
            titleLabel.userInteractionEnabled = YES;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.tag = i;
            
            if (i == 0) {
                titleLabel.font = [UIFont systemFontOfSize:13.0];
                titleLabel.textColor = [UIColor whiteColor];
            } else {
                titleLabel.font = [UIFont systemFontOfSize:13.0];
                titleLabel.textColor = UIColorFromRGB(245.0, 101.0, 77.0);
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(pressed:)];
            [tap setNumberOfTapsRequired:1];
            [tap setNumberOfTouchesRequired:1];
            [titleLabel addGestureRecognizer:tap];
            
            [self addSubview:titleLabel];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        self.frame = CGRectMake(0.0, 0.0, VIEW_WIDTH, self.frame.size.height);
        self.contentSize = CGSizeMake(self.frame.size.width / 4.0 * ([self.discountCategoryArray count] + 1) + 10.0 * 2.0,
                                      self.frame.size.height);
    });
}

- (void)pressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UILabel *titleLabel = (UILabel *)tapGestureRecognizer.view;
    [self switchTab:titleLabel.tag isLoadData:YES];
}

- (void)switchTab:(NSUInteger)currentSelectedIndex isLoadData:(BOOL)isLoadData
{
    if (currentSelectedIndex != self.selectedIndex) {
        self.selectedIndex = currentSelectedIndex;

        CGFloat width = VIEW_WIDTH / 4.0;
        [UIView animateWithDuration:0.25 animations:^{
            UIImageView *selectedImageView = (UIImageView *)[self viewWithTag:SELECTED_IMAGE_VIEW];
            selectedImageView.frame = CGRectMake(width * (self.selectedIndex) + 10.0,
                                                 selectedImageView.frame.origin.y,
                                                 selectedImageView.frame.size.width,
                                                 selectedImageView.frame.size.height);
            
            for (NSUInteger i = 1; i < [self.subviews count]; i++) {
                UILabel *titleLabel = (UILabel *)[self.subviews objectAtIndex:i];
                if (i - 1 == self.selectedIndex) {
                    titleLabel.font = [UIFont systemFontOfSize:13.0];
                    titleLabel.textColor = [UIColor whiteColor];
                } else {
                    titleLabel.font = [UIFont systemFontOfSize:13.0];
                    titleLabel.textColor = UIColorFromRGB(245.0, 101.0, 77.0);
                }
            }
        }];
        
        if (isLoadData) {
            [self.menuDelegate switchDiscountCategoryIndex:self.selectedIndex];
        }
    }
}

- (void)tapDiscountCategory:(NSNumber *)discountCategoryID
{
    NSUInteger selectedIndex = 0;
    for (NSUInteger i = 0; i < [self.discountCategoryArray count]; i++) {
        DiscountCategory *discountCategory = [self.discountCategoryArray objectAtIndex:i];
        if ([discountCategory.discountCategoryID isEqualToNumber:discountCategoryID]) {
            selectedIndex = i + 1;
            break;
        }
    }
    
    [self switchTab:selectedIndex isLoadData:NO];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat width = VIEW_WIDTH / 4.0;
        self.contentOffset = CGPointMake(width * selectedIndex, 0.0);
    }];
}

@end
