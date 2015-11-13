//
//  MemberCenterTableViewCell.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-24.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MemberCenterTableViewFirstCell                = 0,
    MemberCenterTableViewMinddleCell              = 1 << 0,
    MemberCenterTableViewLastCell                 = 1 << 1
} MemberCenterTableViewCellStyle;

@interface MemberCenterTableViewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)systemCellStyle customCellStyle:(MemberCenterTableViewCellStyle)memberCenterTableViewCellStyle;

@end
