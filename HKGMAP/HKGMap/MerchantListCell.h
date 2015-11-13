//
//  MerchantListCell.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-9.
//
//

#import <UIKit/UIKit.h>

@interface MerchantListCell : UITableViewCell

- (void)setImageURLString:(NSString *)imageURLString;
- (void)setTitle:(NSString *)title;
- (void)setSnippet:(NSString *)snippet;
- (void)setCategory:(NSString *)category;
- (void)setDistance:(NSString *)distance;

@end
