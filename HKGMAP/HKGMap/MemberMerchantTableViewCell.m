//
//  MemberMerchantTableViewCell.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-22.
//
//

#import "ViewSize.h"
#import "Macros.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"

#define kCellHeight 92.0

#define kImageViewX 13.0
#define kImageViewY 13.0
#define kImageWidth 84.0
#define kImageHeight 62.0

#define kTitleX 111.0
#define kTitleY 7.0
#define kTitleWidth 200.0
#define kTitleHeight 32.0

#define kSnippetX kTitleX
#define kSnippetY 37.0
#define kSnippetWidth 200.0
#define kSnippetHeight 11.0

#define kCategoryX kTitleX
#define kCategoryY 55.0
#define kCategoryWidth 200.0
#define kCategoryHeight 11.0
#define kCategoryFontColor kSnippetFontColor

#define kDistanceX 15.0
#define kDistanceY 66.0
#define kDistanceWidth 50.0
#define kDistanceHeight 11.0
#define kDistanceFontColor [UIColor colorWithRed:(187.0/255.0) green:(45.0/255.0) blue:(26.0/255.0) alpha:1.0]

#import "MemberMerchantTableViewCell.h"

@interface MemberMerchantTableViewCell ()

@property (nonatomic, retain) NSNumber *currentMerchantID;
@property (nonatomic, retain) NSIndexPath *currentIndexPath;
@property (nonatomic, retain) UILabel *snippetLabel;
@property (nonatomic, retain) UILabel *categoryLabel;
@property (nonatomic, retain) UIButton *cancelButton;

@end

@implementation MemberMerchantTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        // Reset frame
        self.frame = CGRectMake(0.0, 0.0, self.frame.size.width, kCellHeight);
        
        // Background color
        self.backgroundColor = [UIColor clearColor];
        
        // Selected background
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = UIColorFromRGB(238.0, 238.0, 238.0);
        
        UIView *selectedBackgroundLineView = [[UIView alloc] init];
        selectedBackgroundLineView.frame = CGRectMake(self.frame.origin.x,
                                                      self.frame.size.height - 1.0,
                                                      self.frame.size.width,
                                                      1.0);
        selectedBackgroundLineView.backgroundColor = UIColorFromRGB(230.0, 227.0, 224.0);
        [self.selectedBackgroundView addSubview:selectedBackgroundLineView];
        
        // Image
        self.imageView.frame = CGRectMake(kImageViewX, kImageViewY, kImageWidth, kImageHeight);
        self.imageView.backgroundColor = [UIColor lightGrayColor];
        self.imageView.layer.borderWidth = 3.0;
        self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.imageView.layer.shadowOpacity = 0.1;
        self.imageView.layer.shadowRadius = 2.0;
        self.imageView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
        self.imageView.image = [UIImage imageNamed:@"Transparent"];
        
        
        // Title
        self.textLabel.frame = CGRectMake(kTitleX, kTitleY, kTitleWidth, kTitleHeight);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
        self.textLabel.font = [UIFont systemFontOfSize:13.0];
        //        [self addSubview:self.titleLabel];
        
        // Snippet
        //        self.snippetLabel = [[UILabel alloc] init];
        self.detailTextLabel.frame = CGRectMake(kSnippetX, kSnippetY, kSnippetWidth, kSnippetHeight);
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.textColor = UIColorFromRGB(176.0, 176.0, 176.0);
        self.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
        //        [self addSubview:self.snippetLabel];
        
        // Category
        self.categoryLabel = [[UILabel alloc] init];
        self.categoryLabel.frame = CGRectMake(kCategoryX, kCategoryY, kCategoryWidth, kCategoryHeight);
        self.categoryLabel.backgroundColor = [UIColor clearColor];
        self.categoryLabel.textColor = UIColorFromRGB(176.0, 176.0, 176.0);
        self.categoryLabel.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:self.categoryLabel];
        
        
        // Cancel Button
        UIImage *cancelButtonImage = [UIImage imageNamed:@"CancelButton"];
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton setBackgroundImage:cancelButtonImage
                                     forState:UIControlStateNormal];
        self.cancelButton.frame = CGRectMake(self.frame.size.width - cancelButtonImage.size.width - 10.0,
                                             45.0,
                                             cancelButtonImage.size.width,
                                             cancelButtonImage.size.height);
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:UIColorFromRGB(139.0, 139.0, 139.0)
                                forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancel:)
                    forControlEvents:UIControlEventTouchDown];
        self.cancelButton.userInteractionEnabled = YES;
        [self.contentView addSubview:self.cancelButton];
        
        
        // Buttom line
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(self.frame.origin.x,
                                    self.frame.size.height - 1.0,
                                    self.frame.size.width,
                                    1.0);
        lineView.backgroundColor = UIColorFromRGB(230.0, 227.0, 224.0);
        [self addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Reset frame
    //    self.frame = CGRectMake(0.0, 0.0, self.frame.size.width, kCellHeight);
    
    // Image
    self.imageView.frame = CGRectMake(kImageViewX, kImageViewY, kImageWidth, kImageHeight);
    
    // Title
    self.textLabel.frame = CGRectMake(kTitleX, kTitleY, kTitleWidth, kTitleHeight);
    
    // Snippet
    self.detailTextLabel.frame = CGRectMake(kSnippetX, kSnippetY, kSnippetWidth, kSnippetHeight);
    
    // Category
    self.categoryLabel.frame = CGRectMake(kCategoryX, kCategoryY, kCategoryWidth, kCategoryHeight);
    
    // Cancel Button
    UIImage *cancelButtonImage = [UIImage imageNamed:@"CancelButton"];
    self.cancelButton.frame = CGRectMake(self.frame.size.width - cancelButtonImage.size.width - 10.0,
                                         45.0,
                                         cancelButtonImage.size.width,
                                         cancelButtonImage.size.height);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setMerchantID:(NSNumber *)currentMerchantID
{
    if (currentMerchantID != nil) {
        self.currentMerchantID = currentMerchantID;
    }
}

- (void)setIndexPath:(NSIndexPath *)currentIndexPath
{
    if (currentIndexPath != nil) {
        self.currentIndexPath = currentIndexPath;
    }
}

- (void)setImageURLString:(NSString *)currentImageURLString
{
    if (currentImageURLString != nil) {
        DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
        progressView.frame = CGRectMake((self.imageView.frame.size.width - 20.0) / 2.0,
                                        (self.imageView.frame.size.height - 20.0) / 2.0,
                                        20.0,
                                        20.0);
        progressView.progress = 0.0;
        [self.imageView addSubview:progressView];
//        [self layoutSubviews];
        
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:currentImageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished && error == nil) {
                self.imageView.image = image;
            }
            
            [progressView removeFromSuperview];
//            [self layoutSubviews];
        }];
    }
}

- (void)setTitle:(NSString *)title
{
    self.textLabel.text = title;
}

- (void)setSnippet:(NSString *)snippet
{
    self.detailTextLabel.text = snippet;
}

- (void)setCategory:(NSString *)category
{
    self.categoryLabel.text = category;
}

- (void)cancel:(UIButton *)button
{
    [self.delegate didSelectCancelButton:self.currentMerchantID indexPath:self.currentIndexPath];
}

@end
