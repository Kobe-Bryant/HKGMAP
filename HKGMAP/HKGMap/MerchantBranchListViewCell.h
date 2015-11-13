//
//  MerchantBranchListViewCell.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import <UIKit/UIKit.h>
#import "Discount.h"

@protocol MerchantBranchListViewCellDelegate <NSObject>

- (void)didSelectRowAtIndex:(NSUInteger)index;
- (void)didSelectDiscount:(NSNumber *)discountID;

@end



@interface MerchantBranchListViewCell : UITableViewCell

@property (nonatomic, assign) id<MerchantBranchListViewCellDelegate> delegate;

- (void)setTitle:(NSString *)title;
- (void)setAddress:(NSString *)address;
- (void)setTraffic:(NSString *)traffic;
- (void)setTelephone:(NSString *)telephone;
- (void)setDiscountArray:(NSArray *)discountArray;
- (void)setSelectedIndex:(NSUInteger)currentSelectedIndex;

@end
