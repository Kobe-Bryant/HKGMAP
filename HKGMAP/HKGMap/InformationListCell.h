//
//  InformationListCell.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import <UIKit/UIKit.h>

@interface InformationListCell : UITableViewCell

- (void)setImageUrlString:(NSString *)imageUrlString;
- (void)setTitle:(NSString *)title;

- (void)setDateString:(NSString *)dateString;
- (void)setHasCoupon:(BOOL)hasCoupon;
- (void)setHasDiscount:(BOOL)hasDiscount;

@end
