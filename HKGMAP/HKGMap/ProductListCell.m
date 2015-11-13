//
//  ProductListCell.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import "ProductListCell.h"
#import "Macros.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"

#define kLeftItemX 15.0
#define kRightItemX 165.0
#define kItemY 15.0
#define kItemWidth 140.0
#define kItemHeight 181.0
#define kImageWidth 140.0
#define kImageHeight 140.0

@interface ProductListCell ()

@property (nonatomic, retain) UIImageView *leftImageView;
@property (nonatomic, retain) UILabel *leftTitleLabel;

@property (nonatomic, retain) UIImageView *rightImageView;
@property (nonatomic, retain) UILabel *rightTitleLabel;

@end

@implementation ProductListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor clearColor];
        
        // Left
        UIView *leftItemView = [[UIView alloc] init];
        leftItemView.frame = CGRectMake(kLeftItemX, kItemY, kItemWidth, kItemHeight);
        [self.contentView addSubview:leftItemView];
        
        self.leftImageView = [[UIImageView alloc] init];
        self.leftImageView.frame = CGRectMake(0.0, 0.0, kImageWidth, kImageHeight);
        self.leftImageView.backgroundColor = [UIColor lightGrayColor];
//        leftImageView.image = [UIImage imageNamed:@"DemoProduct1"];
        [leftItemView addSubview:self.leftImageView];
        
        UIView *leftLineView = [[UIView alloc] init];
        leftLineView.frame = CGRectMake(self.leftImageView.frame.origin.x,
                                        CGRectGetMaxY(self.leftImageView.frame),
                                        self.leftImageView.frame.size.width,
                                        1.0);
        leftLineView.backgroundColor = UIColorFromRGB(234.0, 232.0, 230.0);
        [leftItemView addSubview:leftLineView];
        
        self.leftTitleLabel = [[UILabel alloc] init];
        self.leftTitleLabel.frame = CGRectMake(leftLineView.frame.origin.x,
                                               CGRectGetMaxY(leftLineView.frame),
                                               leftLineView.frame.size.width,
                                               40.0);
        self.leftTitleLabel.backgroundColor = [UIColor clearColor];
        self.leftTitleLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
        self.leftTitleLabel.font = [UIFont systemFontOfSize:12.0];
        self.leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.leftTitleLabel.numberOfLines = 2;
//        leftTitleLabel.text = @"Women's Signorina Eau De Toilette, 3.4 fl.oz";
        [leftItemView addSubview:self.leftTitleLabel];
        
        UITapGestureRecognizer *leftItemTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(pressed:)];
        leftItemTap.numberOfTapsRequired = 1;
        leftItemTap.numberOfTouchesRequired = 1;
        [leftItemView addGestureRecognizer:leftItemTap];
        
        // Right
        UIView *rightItemView = [[UIView alloc] init];
        rightItemView.frame = CGRectMake(kRightItemX, kItemY, kItemWidth, kItemHeight);
        [self.contentView addSubview:rightItemView];
        
        self.rightImageView = [[UIImageView alloc] init];
        self.rightImageView.frame = CGRectMake(0.0, 0.0, kImageWidth, kImageHeight);
        self.rightImageView.backgroundColor = [UIColor lightGrayColor];
//        rightImageView.image = [UIImage imageNamed:@"DemoProduct1"];
        [rightItemView addSubview:self.rightImageView];
        
        UIView *rightLineView = [[UIView alloc] init];
        rightLineView.frame = CGRectMake(self.rightImageView.frame.origin.x,
                                         CGRectGetMaxY(self.rightImageView.frame),
                                         self.rightImageView.frame.size.width,
                                         1.0);
        rightLineView.backgroundColor = UIColorFromRGB(234.0, 232.0, 230.0);
        [rightItemView addSubview:rightLineView];
        
        self.rightTitleLabel = [[UILabel alloc] init];
        self.rightTitleLabel.frame = CGRectMake(rightLineView.frame.origin.x,
                                                CGRectGetMaxY(rightLineView.frame),
                                                rightLineView.frame.size.width,
                                                40.0);
        self.rightTitleLabel.backgroundColor = [UIColor clearColor];
        self.rightTitleLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
        self.rightTitleLabel.font = [UIFont systemFontOfSize:12.0];
        self.rightTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.rightTitleLabel.numberOfLines = 2;
//        rightTitleLabel.text = @"Women's Signorina Eau De Toilette, 3.4 fl.oz";
        [rightItemView addSubview:self.rightTitleLabel];
        
        UITapGestureRecognizer *rightItemTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(pressed:)];
        rightItemTap.numberOfTapsRequired = 1;
        rightItemTap.numberOfTouchesRequired = 1;
        [rightItemView addGestureRecognizer:rightItemTap];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)pressed:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.delegate didSelectRowAtIndex:tapGestureRecognizer.view.tag];
}

- (void)setLeftProduct:(Product *)product
{
    if (product != nil) {
        DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
        progressView.frame = CGRectMake((self.leftImageView.frame.size.width - 20.0) / 2.0,
                                        (self.leftImageView.frame.size.height - 20.0) / 2.0,
                                        20.0,
                                        20.0);
        progressView.progress = 0.0;
        self.leftImageView.backgroundColor = [UIColor lightGrayColor];
        [self.leftImageView addSubview:progressView];
        [self layoutSubviews];
        
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:product.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished && error == nil) {
                self.leftImageView.image = image;
            }
            
            [progressView removeFromSuperview];
            [self layoutSubviews];
        }];
        
        
        self.leftTitleLabel.text = product.title;
    } else {
        self.leftImageView.hidden = YES;
        self.leftTitleLabel.hidden = YES;
    }
}

- (void)setLeftProductIndex:(NSUInteger)index
{
    UIView *leftItemView = [self.contentView.subviews objectAtIndex:0];
    leftItemView.tag = index;
}

- (void)setRightProduct:(Product *)product
{
    if (product != nil) {
        DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
        progressView.frame = CGRectMake((self.leftImageView.frame.size.width - 20.0) / 2.0,
                                        (self.leftImageView.frame.size.height - 20.0) / 2.0,
                                        20.0,
                                        20.0);
        progressView.progress = 0.0;
        self.rightImageView.backgroundColor = [UIColor lightGrayColor];
        [self.rightImageView addSubview:progressView];
        [self layoutSubviews];
        
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:product.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished && error == nil) {
                self.rightImageView.image = image;
            }
            
            [progressView removeFromSuperview];
            [self layoutSubviews];
        }];
        
        
        self.rightTitleLabel.text = product.title;
    } else {
        self.rightImageView.hidden = YES;
        self.rightTitleLabel.hidden = YES;
    }
}

- (void)setRightProductIndex:(NSUInteger)index
{
    UIView *rightItemView = [self.contentView.subviews objectAtIndex:1];
    rightItemView.tag = index;
}

@end
