//
//  MerchantBranchListViewCell.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#define CELL_HEIGHT 185.0

#import "MerchantBranchListViewCell.h"
#import "Macros.h"
#import "Discount.h"

@interface MerchantBranchListViewCell ()

@property (nonatomic, retain) UIView *line1;
@property (nonatomic, retain) UIView *line2;
@property (nonatomic, retain) UIImageView *locationImageView;
@property (nonatomic, retain) UIButton *locationButton;
//@property (nonatomic, retain) NSString *currentAddress;
@property (nonatomic, retain) UILabel *addressLabel;
//@property (nonatomic, retain) NSString *currentTraffic;
@property (nonatomic, retain) UILabel *trafficLabel;
//@property (nonatomic, retain) NSString *currentTelephone;
@property (nonatomic, retain) UILabel *telephoneLabel;
@property (nonatomic, retain) UIView *discountView;
//@property (nonatomic, retain) NSArray *currentDiscountArray;
@property (nonatomic, readwrite) CGFloat lastDiscountY;
@property (nonatomic, readwrite) NSUInteger currentSelectedIndex;

@end

@implementation MerchantBranchListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.frame = CGRectMake(15.0,
                                            15.0,
                                            self.frame.size.width - 15.0 * 2.0,
                                            CELL_HEIGHT - 15.0);
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.line1 = [[UIView alloc] init];
        self.line1.frame = CGRectMake(0.0, 95.0, self.contentView.frame.size.width, 1.0);
        self.line1.backgroundColor = UIColorFromRGB(221.0, 221.0, 221.0);
        [self.contentView addSubview:self.line1];
        
        self.line2 = [[UIView alloc] init];
        self.line2.frame = CGRectMake(0.0,
                                      self.contentView.frame.size.height - 1.0,
                                      self.contentView.frame.size.width,
                                      1.0);
        self.line2.backgroundColor = UIColorFromRGB(221.0, 221.0, 221.0);
        [self.contentView addSubview:self.line2];
        
        
        UIImage *locationImage = [UIImage imageNamed:@"MerchantBranchLocation"];
//        self.locationImageView = [[UIImageView alloc] init];
//        self.locationImageView.image = [UIImage imageNamed:@"MerchantBranchLocation"];
//        self.locationImageView.frame = CGRectMake(self.contentView.frame.size.width - self.locationImageView.image.size.width - 10.0,
//                                                  10.0,
//                                                  self.locationImageView.image.size.width,
//self.                                             self.locationImageView.image.size.height);
//        self.locationImageView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGesture:)];
//        tapImage.numberOfTapsRequired = 1;
//        tapImage.numberOfTouchesRequired = 1;
//        [self.locationImageView addGestureRecognizer:tapImage];
//        [self.contentView addSubview:self.locationImageView];
        self.locationButton = [[UIButton alloc] init];
        self.locationButton.frame = CGRectMake(self.contentView.frame.size.width - locationImage.size.width - 10.0,
                                               10.0,
                                               locationImage.size.width,
                                               locationImage.size.height);
        [self.locationButton setBackgroundImage:locationImage
                                       forState:UIControlStateNormal];
        [self.locationButton addTarget:self action:@selector(tapImage:)
                      forControlEvents:UIControlEventTouchDown];
        self.locationButton.userInteractionEnabled = YES;
        [self.contentView addSubview:self.locationButton];


        self.textLabel.frame = CGRectMake(12.0,
                                          13.0,
                                          self.contentView.frame.size.width - 12.0 - self.locationImageView.image.size.width - 10.0 * 2.0,
                                          17.0);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        [self.textLabel sizeToFit];
        
        
        self.addressLabel = [[UILabel alloc] init];
        self.addressLabel.frame = CGRectMake(12.0,
                                             CGRectGetMaxY(self.textLabel.frame) + 8.0,
                                             self.contentView.frame.size.width - 12.0 * 2.0,
                                             11.0);
        self.addressLabel.backgroundColor = [UIColor clearColor];
        self.addressLabel.textColor = UIColorFromRGB(176.0, 176.0, 176.0);
        self.addressLabel.font = [UIFont systemFontOfSize:11.0];
//        self.addressLabel.text = self.currentAddress;
        [self.addressLabel sizeToFit];
        [self.contentView addSubview:self.addressLabel];
        
        
        self.trafficLabel = [[UILabel alloc] init];
        self.trafficLabel.frame = CGRectMake(12.0,
                                             CGRectGetMaxY(self.addressLabel.frame) + 5.0,
                                             self.contentView.frame.size.width - 12.0 * 2.0,
                                             11.0);
        self.trafficLabel.backgroundColor = [UIColor clearColor];
        self.trafficLabel.textColor = UIColorFromRGB(176.0, 176.0, 176.0);
        self.trafficLabel.font = [UIFont systemFontOfSize:11.0];
//        self.trafficLabel.text = self.currentTraffic;
        [self.trafficLabel sizeToFit];
        [self.contentView addSubview:self.trafficLabel];
        
        
        self.telephoneLabel = [[UILabel alloc] init];
        self.telephoneLabel.frame = CGRectMake(12.0,
                                               CGRectGetMaxY(self.trafficLabel.frame) + 5.0,
                                               self.contentView.frame.size.width - 12.0 * 2.0,
                                               11.0);
        self.telephoneLabel.backgroundColor = [UIColor clearColor];
        self.telephoneLabel.textColor = UIColorFromRGB(176.0, 176.0, 176.0);
        self.telephoneLabel.font = [UIFont systemFontOfSize:11.0];
//        self.telephoneLabel.text = self.currentTelephone;
        [self.telephoneLabel sizeToFit];
        [self.contentView addSubview:self.telephoneLabel];
        
        
        self.discountView = [[UIView alloc] init];
        self.discountView.frame = CGRectMake(12.0,
                                             CGRectGetMaxY(self.line1.frame) + 10.0,
                                             self.contentView.frame.size.width - 12.0 * 2.0,
                                             55.0);
//        self.discountView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.discountView];
        /*
        UIImage *dotImage = [UIImage imageNamed:@"MerchantBranchDot"];
        for (NSUInteger i = 0; i < [self.currentDiscountArray count]; i++) {
            UIImageView *dotImageView = [[UIImageView alloc] initWithImage:dotImage];
            if (i == 0) {
                dotImageView.frame = CGRectMake(12.0,
                                                CGRectGetMaxY(self.line1.frame) + 17.0,
                                                dotImage.size.width,
                                                dotImage.size.height);
            } else {
                dotImageView.frame = CGRectMake(12.0,
                                                self.lastDiscountY + 8.0,
                                                dotImage.size.width,
                                                dotImage.size.height);
            }
            [self.contentView addSubview:dotImageView];
            
            UILabel *discountLabel = [[UILabel alloc] init];
            if (i == 0) {
                discountLabel.frame = CGRectMake(CGRectGetMaxX(dotImageView.frame) + 8.0,
                                                 CGRectGetMaxY(self.line1.frame) + 12.0,
                                                 240.0,
                                                 12.0);
            } else {
                discountLabel.frame = CGRectMake(CGRectGetMaxX(dotImageView.frame) + 8.0,
                                                 self.lastDiscountY + 2.0,
                                                 240.0,
                                                 12.0);
            }
            
            discountLabel.backgroundColor = [UIColor clearColor];
            discountLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
            discountLabel.font = [UIFont systemFontOfSize:12.0];
            discountLabel.text = [self.currentDiscountArray objectAtIndex:i];
            discountLabel.numberOfLines = 9999;
            [discountLabel sizeToFit];
            [self.contentView addSubview:discountLabel];
            
            self.lastDiscountY = CGRectGetMaxY(discountLabel.frame);
        }
         */
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    self.contentView.frame = CGRectMake(15.0,
                                        15.0,
                                        self.frame.size.width - 15.0 * 2.0,
                                        CELL_HEIGHT - 15.0);
    
    self.line1.frame = CGRectMake(0.0, 95.0, self.contentView.frame.size.width, 1.0);
    
    self.line2.frame = CGRectMake(0.0,
                                  self.contentView.frame.size.height - 1.0,
                                  self.contentView.frame.size.width,
                                  1.0);

    UIImage *locationImage = [UIImage imageNamed:@"MerchantBranchLocation"];
    self.locationButton.frame = CGRectMake(self.contentView.frame.size.width - locationImage.size.width - 10.0,
                                           10.0,
                                           locationImage.size.width,
                                           locationImage.size.height);

    self.textLabel.frame = CGRectMake(12.0,
                                      13.0,
                                      self.contentView.frame.size.width - 12.0 - self.locationImageView.image.size.width - 10.0 * 2.0,
                                      17.0);


    self.addressLabel.frame = CGRectMake(12.0,
                                         CGRectGetMaxY(self.textLabel.frame) + 8.0,
                                         self.contentView.frame.size.width - 12.0 * 2.0,
                                         11.0);


    self.trafficLabel.frame = CGRectMake(12.0,
                                         CGRectGetMaxY(self.addressLabel.frame) + 5.0,
                                         self.contentView.frame.size.width - 12.0 * 2.0,
                                         11.0);


    self.telephoneLabel.frame = CGRectMake(12.0,
                                         CGRectGetMaxY(self.trafficLabel.frame) + 5.0,
                                         self.contentView.frame.size.width - 12.0 * 2.0,
                                         11.0);

    self.discountView.frame = CGRectMake(12.0,
                                         CGRectGetMaxY(self.line1.frame) + 10.0,
                                         self.contentView.frame.size.width - 12.0 * 2.0,
                                         55.0);
}

- (void)tapImage:(UIButton *)button
{
    [self.delegate didSelectRowAtIndex:self.currentSelectedIndex];
}

- (void)tapDiscount:(UIGestureRecognizer *)gestureRecognizer
{
    [self.delegate didSelectDiscount:[NSNumber numberWithUnsignedInteger:gestureRecognizer.view.tag]];
}

- (void)setTitle:(NSString *)title
{
    self.textLabel.text = title;
}

- (void)setAddress:(NSString *)currentAddress
{
    self.addressLabel.text = currentAddress;
}

- (void)setTraffic:(NSString *)currentTraffic
{
    
    self.trafficLabel.text = currentTraffic;
}

- (void)setTelephone:(NSString *)currentTelephone
{
    self.telephoneLabel.text = currentTelephone;
}

- (void)setDiscountArray:(NSArray *)currentDiscountArray
{
    if (currentDiscountArray != nil) {
        UIImage *dotImage = [UIImage imageNamed:@"MerchantBranchDot"];
        for (NSUInteger i = 0; i < [currentDiscountArray count]; i++) {
            Discount *discount = [currentDiscountArray objectAtIndex:i];
            
            UIImageView *dotImageView = [[UIImageView alloc] initWithImage:dotImage];
            if (i == 0) {
                dotImageView.frame = CGRectMake(0.0,
                                                5.0,
                                                dotImage.size.width,
                                                dotImage.size.height);
            } else {
                dotImageView.frame = CGRectMake(0.0,
                                                self.lastDiscountY + 7.0,
                                                dotImage.size.width,
                                                dotImage.size.height);
            }
            [self.discountView addSubview:dotImageView];
            
            UILabel *discountLabel = [[UILabel alloc] init];
            if (i == 0) {
                discountLabel.frame = CGRectMake(CGRectGetMaxX(dotImageView.frame) + 8.0,
                                                 0.0,
                                                 self.discountView.frame.size.width,
                                                 12.0);
            } else {
                discountLabel.frame = CGRectMake(CGRectGetMaxX(dotImageView.frame) + 8.0,
                                                 self.lastDiscountY + 2.0,
                                                 self.discountView.frame.size.width,
                                                 12.0);
            }
            
            discountLabel.backgroundColor = [UIColor clearColor];
            discountLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
            discountLabel.font = [UIFont systemFontOfSize:12.0];
            discountLabel.text = discount.title;
            discountLabel.numberOfLines = 9999;
            [discountLabel sizeToFit];
            discountLabel.tag = [discount.discountID integerValue];
            discountLabel.userInteractionEnabled = YES;
            [self.discountView addSubview:discountLabel];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDiscount:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [discountLabel addGestureRecognizer:tap];
            
            self.lastDiscountY = CGRectGetMaxY(discountLabel.frame);
            if (self.lastDiscountY > self.discountView.frame.size.height) {
                discountLabel.hidden = YES;
            }
        }
    }
}

- (void)setSelectedIndex:(NSUInteger)currentSelectedIndex
{
    self.currentSelectedIndex = currentSelectedIndex;
}
@end
