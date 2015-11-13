//
//  MemberFieldTableViewCell.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-24.
//
//

#import "FeedbackTableViewCell.h"
#import "Macros.h"

@interface FeedbackTableViewCell ()

@property (nonatomic, readwrite) FeedbackTableViewCellStyle feedbackTableViewCellStyle;

@end

@implementation FeedbackTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.frame = CGRectMake(25.0,
                                            0.0,
                                            frame.size.width - 25.0 * 2.0,
                                            frame.size.height);
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 4.0;


        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.frame = CGRectMake(0.0,
                                               0.0,
                                               self.contentView.frame.size.width,
                                               self.contentView.frame.size.height);
        UIView *shadowView = [[UIView alloc] init];
        shadowView.frame = self.contentView.frame;
        shadowView.layer.cornerRadius = 4.0;
        shadowView.layer.shadowColor = [UIColorFromRGB(221.0, 221.0, 221.0) CGColor];
        shadowView.layer.shadowOpacity = 1.0;
        shadowView.layer.shadowRadius = 0.125;
        shadowView.layer.shadowOffset = CGSizeMake(0.0, 0.5);
        shadowView.backgroundColor = [UIColor whiteColor];
        [self.backgroundView addSubview:shadowView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(25.0,
                                        0.0,
                                        self.frame.size.width - 25.0 * 2.0,
                                        self.frame.size.height);
}

@end
