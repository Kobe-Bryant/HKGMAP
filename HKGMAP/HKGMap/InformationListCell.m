//
//  InformationListCell.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import "InformationListCell.h"

//#define kItemX 10.0
//#define kItemY 10.0
//#define kItemWidth 300.0
//#define kItemHeight 205.0

//#define kImageWidth kItemWidth
//#define kImageHeight 150.0
//
//#define kTitleX 20.0
//#define kTitleY kImageHeight+16.0
//#define kTitleWidth kItemWidth-kTitleX*2.0
//#define kTitleHeight 20.0
//
//#define kDateX kTitleX
//#define kDateY kTitleY+kTitleHeight+3.0
//#define kDateWidth kTitleWidth
//#define kDateHeight 18.0
//
//#define kCouponImageX 235.0
//#define kCouponTag 2111
//
//#define kDiscountImageX 270.0
//#define kDiscountTag 2112

@interface InformationListCell ()

@property (nonatomic, retain) NSString *currentImageUrlString;
@property (nonatomic, retain) NSString *currentTitle;
@property (nonatomic, retain) NSString *currentDateString;
@property (nonatomic, readwrite) BOOL currentHasCoupon;
@property (nonatomic, readwrite) BOOL currentHasDiscount;

@end

@implementation InformationListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];


    // Content
    self.contentView.frame = CGRectMake(10.0,
                                        10.0,
                                        self.frame.size.width - 10.0 * 2.0,
                                        205.0);
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 3.0;
    self.contentView.layer.masksToBounds = YES;
    
    
    // Background
    self.backgroundView = [[UIView alloc] init];
    UIView *shadowView = [[UIView alloc] init];
    shadowView.frame = self.contentView.frame;
    shadowView.layer.cornerRadius = 3.0;
    shadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
    shadowView.layer.shadowOpacity = 0.1;
    shadowView.layer.shadowRadius = 2.0;
    shadowView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    shadowView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:shadowView];

    
    
    // Image
    self.imageView.frame = CGRectMake(0.0,
                                      0.0,
                                      self.contentView.frame.size.width,
                                      150.0);
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.image = [UIImage imageNamed:self.currentImageUrlString];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds
//                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
//                                                         cornerRadii:CGSizeMake(3.0, 3.0)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.imageView.frame;
//    maskLayer.path = maskPath.CGPath;
//    self.imageView.layer.mask = maskLayer;


    // Title
    self.textLabel.frame = CGRectMake(12.0,
                                      CGRectGetMaxY(self.imageView.frame) + 11.0,
                                      self.contentView.frame.size.width - 12.0 * 2.0,
                                      13.0);
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:13.0];
    self.textLabel.text = self.currentTitle;
    [self.textLabel sizeToFit];


    // Date
    self.detailTextLabel.frame = CGRectMake(12.0,
                                            CGRectGetMaxY(self.textLabel.frame) + 7.0,
                                            self.contentView.frame.size.width - 12.0 * 2.0,
                                            11.0);
    self.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
    self.detailTextLabel.textColor = [UIColor lightGrayColor];
    self.detailTextLabel.text = self.currentDateString;
    [self.detailTextLabel sizeToFit];

    
    // Coupon
    UIImageView *couponImageView = [[UIImageView alloc] init];
    couponImageView.image = [UIImage imageNamed:@"InformationCoupon"];
    couponImageView.frame = CGRectMake(215.0,
                                       -2.0,
                                       couponImageView.image.size.width,
                                       couponImageView.image.size.height);
    couponImageView.hidden = !self.currentHasCoupon;
    [self.contentView addSubview:couponImageView];


    // Discount
    UIImageView *discountImageView = [[UIImageView alloc] init];
    discountImageView.image = [UIImage imageNamed:@"InformationDiscount"];
    discountImageView.frame = CGRectMake(250.0,
                                         -2.0,
                                         discountImageView.image.size.width,
                                         discountImageView.image.size.height);
    discountImageView.hidden = !self.currentHasDiscount;
    [self.contentView addSubview:discountImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageUrlString:(NSString *)currentImageUrlString
{
    if (currentImageUrlString != nil) {
        self.currentImageUrlString = currentImageUrlString;
    }
}

- (void)setTitle:(NSString *)currentTitle
{
    if (currentTitle != nil) {
        self.currentTitle = currentTitle;
    }
}

- (void)setDateString:(NSString *)currentDateString
{
    if (currentDateString != nil) {
        self.currentDateString = currentDateString;
    }
}

- (void)setHasCoupon:(BOOL)currentHasCoupon
{
    self.currentHasCoupon = currentHasCoupon;
}

- (void)setHasDiscount:(BOOL)currentHasDiscount
{
    self.currentHasDiscount = currentHasDiscount;
}

@end
