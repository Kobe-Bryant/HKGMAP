//
//  CalendarInformationCell.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-21.
//
//

#define CELL_HEIGHT 65.0

#import "CalendarInformationCell.h"
#import "Macros.h"

@implementation CalendarInformationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = UIColorFromRGB(242.0, 239.0, 235.0);
        
        
        UIImage *backgroundBottomImage = [UIImage imageNamed:@"InformationFrameButtom"];
        self.contentView.frame = CGRectMake((self.frame.size.width - backgroundBottomImage.size.width) / 2.0,
                                            0.0,
                                            backgroundBottomImage.size.width,
                                            CELL_HEIGHT - 5.0);
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:backgroundBottomImage];
        bottomImageView.frame = CGRectMake(0.0,
                                           (self.contentView.frame.size.height - backgroundBottomImage.size.height),
                                           backgroundBottomImage.size.width,
                                           backgroundBottomImage.size.height);
        [self.contentView addSubview:bottomImageView];
        
        
        self.textLabel.frame = CGRectMake(13.0, 29.0, self.frame.size.width - 13.0 * 4.0, 12.0);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
        self.textLabel.font = [UIFont systemFontOfSize:12.0];
        self.textLabel.numberOfLines = 1;
        [self.textLabel sizeToFit];
        
        
        self.detailTextLabel.frame = CGRectMake(13.0, 10.0, self.frame.size.width - 13.0 * 4.0, 11.0);
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.textColor = UIColorFromRGB(176.0, 176.0, 176.0);
        self.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
        self.detailTextLabel.numberOfLines = 1;
        [self.detailTextLabel sizeToFit];
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
    UIImage *backgroundBottomImage = [UIImage imageNamed:@"InformationFrameButtom"];
    self.contentView.frame = CGRectMake((self.frame.size.width - backgroundBottomImage.size.width) / 2.0,
                                        0.0,
                                        backgroundBottomImage.size.width,
                                        CELL_HEIGHT - 5.0);

    self.textLabel.frame = CGRectMake(13.0,
                                      29.0,
                                      self.frame.size.width - 13.0 * 4.0,
                                      12.0);
    self.textLabel.backgroundColor = [UIColor clearColor];

    
    self.detailTextLabel.frame = CGRectMake(13.0,
                                            10.0,
                                            self.frame.size.width - 13.0 * 4.0,
                                            11.0);
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
}

@end
