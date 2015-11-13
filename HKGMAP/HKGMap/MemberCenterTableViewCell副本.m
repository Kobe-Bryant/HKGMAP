//
//  MemberCenterTableViewCell.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-24.
//
//

#define BOTTOM_LINE_TAG 0301
#define SHADOW_VIEW_TAG 0302

#import "MemberCenterTableViewCell.h"
#import "Macros.h"

@interface MemberCenterTableViewCell ()

@property (nonatomic, readwrite) MemberCenterTableViewCellStyle memberCenterTableViewCellStyle;

@end

@implementation MemberCenterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)systemCellStyle customCellStyle:(MemberCenterTableViewCellStyle)memberCenterTableViewCellStyle;
{
    self = [super initWithStyle:systemCellStyle reuseIdentifier:nil];
    if (self) {
        // Initialization code
        self.memberCenterTableViewCellStyle = memberCenterTableViewCellStyle;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.layer.zPosition = 1001.0;
        self.contentView.frame = CGRectMake(15.0,
                                            0.0,
                                            self.frame.size.width - 15.0 * 2.0,
                                            self.frame.size.height);
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        if (self.memberCenterTableViewCellStyle == MemberCenterTableViewFirstCell) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds
                                                           byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                                 cornerRadii:CGSizeMake(4.0, 4.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.contentView.layer.mask = maskLayer;
            
            UIView *bottomLine = [[UIView alloc] init];
            bottomLine.frame = CGRectMake(0.0,
                                          self.contentView.frame.size.height - 0.5,
                                          self.contentView.frame.size.width,
                                          0.5);
            bottomLine.backgroundColor = UIColorFromRGB(221.0, 221.0, 221.0);
            bottomLine.tag = BOTTOM_LINE_TAG;
            [self.contentView addSubview:bottomLine];
        } else if (self.memberCenterTableViewCellStyle == MemberCenterTableViewLastCell) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds
                                                           byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                                 cornerRadii:CGSizeMake(4.0, 4.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.contentView.layer.mask = maskLayer;
            
            UIView *shadowView = [[UIView alloc] init];
            shadowView.frame = self.contentView.frame;
            shadowView.layer.cornerRadius = 4.0;
            shadowView.layer.shadowColor = [UIColorFromRGB(221.0, 221.0, 221.0) CGColor];
            shadowView.layer.shadowOpacity = 1.0;
            shadowView.layer.shadowRadius = 0.125;
            shadowView.layer.shadowOffset = CGSizeMake(0.0, 0.5);
            shadowView.backgroundColor = [UIColor whiteColor];
            shadowView.tag = SHADOW_VIEW_TAG;
            [self addSubview:shadowView];
        } else {
            UIView *bottomLine = [[UIView alloc] init];
            bottomLine.frame = CGRectMake(0.0,
                                          self.contentView.frame.size.height - 0.5,
                                          self.contentView.frame.size.width,
                                          0.5);
            bottomLine.backgroundColor = UIColorFromRGB(221.0, 221.0, 221.0);
            bottomLine.tag = BOTTOM_LINE_TAG;
            [self.contentView addSubview:bottomLine];
        }
        
        
        self.textLabel.frame = CGRectMake(14.0,
                                          0.0,
                                          self.contentView.frame.size.width,
                                          self.contentView.frame.size.height);
        self.textLabel.textColor = UIColorFromRGB(51.0, 51.0, 51.0);
        self.textLabel.font = [UIFont systemFontOfSize:15.0];

        
        if (self.accessoryView != nil) {
            self.accessoryView.frame = CGRectMake(self.contentView.frame.size.width - self.accessoryView.frame.size.width,
                                                  (self.contentView.frame.size.height - self.accessoryView.frame.size.height) / 2.0,
                                                  self.accessoryView.frame.size.width,
                                                  self.accessoryView.frame.size.height);
        }
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
    self.contentView.frame = CGRectMake(15.0,
                                        0.0,
                                        self.frame.size.width - 15.0 * 2.0,
                                        self.frame.size.height);

    if (self.memberCenterTableViewCellStyle == MemberCenterTableViewFirstCell) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds
                                                       byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                             cornerRadii:CGSizeMake(4.0, 4.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
        
        UIView *bottomLine = [self viewWithTag:BOTTOM_LINE_TAG];
        bottomLine.frame = CGRectMake(0.0,
                                      self.contentView.frame.size.height - 0.5,
                                      self.contentView.frame.size.width,
                                      0.5);
    } else if (self.memberCenterTableViewCellStyle == MemberCenterTableViewLastCell) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds
                                                       byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                             cornerRadii:CGSizeMake(4.0, 4.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
        
        UIView *shadowView = [self viewWithTag:SHADOW_VIEW_TAG];
        shadowView.frame = self.contentView.frame;
    } else {
        UIView *bottomLine = [self viewWithTag:BOTTOM_LINE_TAG];
        bottomLine.frame = CGRectMake(0.0,
                                      self.contentView.frame.size.height - 0.5,
                                      self.contentView.frame.size.width,
                                      0.5);
    }
    
    
    self.textLabel.frame = CGRectMake(14.0,
                                      0.0,
                                      self.contentView.frame.size.width,
                                      self.contentView.frame.size.height);
    
    
    if (self.accessoryView != nil) {
        self.accessoryView.frame = CGRectMake(self.contentView.frame.size.width - self.accessoryView.frame.size.width,
                                              (self.contentView.frame.size.height - self.accessoryView.frame.size.height) / 2.0,
                                              self.accessoryView.frame.size.width,
                                              self.accessoryView.frame.size.height);
    }
}

@end
