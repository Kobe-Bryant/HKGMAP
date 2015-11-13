//
//  FeedbackTableViewCell.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-18.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FeedbackTableViewCellFirstCell                = 0,
    FeedbackTableViewCellLastCell                 = 1 << 0
} FeedbackTableViewCellStyle;

@interface FeedbackTableViewCell : UITableViewCell

//- (id)initWithStyle:(UITableViewCellStyle)systemCellStyle customCellStyle:(FeedbackTableViewCellStyle)feedbackTableViewCellStyle;

@end
