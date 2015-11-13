//
//  MemberMerchantTableViewCell.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-22.
//
//

#import <UIKit/UIKit.h>

@protocol MemberMerchantTableViewCellDelegate <NSObject>

- (void)didSelectCancelButton:(NSNumber *)merchantID indexPath:(NSIndexPath *)indexPath;

@end



@interface MemberMerchantTableViewCell : UITableViewCell

@property (nonatomic, assign) id<MemberMerchantTableViewCellDelegate> delegate;

- (void)setMerchantID:(NSNumber *)currentMerchantID;
- (void)setIndexPath:(NSIndexPath *)currentIndexPath;
- (void)setImageURLString:(NSString *)imageURLString;
- (void)setTitle:(NSString *)title;
- (void)setSnippet:(NSString *)snippet;
- (void)setCategory:(NSString *)category;

@end
