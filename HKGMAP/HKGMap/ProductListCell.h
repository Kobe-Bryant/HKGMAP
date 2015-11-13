//
//  ProductListCell.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import <UIKit/UIKit.h>
#import "Product.h"

@protocol ProductListCellDelegate <NSObject>

- (void)didSelectRowAtIndex:(NSUInteger)index;

@end



@interface ProductListCell : UITableViewCell

@property (nonatomic, assign) id<ProductListCellDelegate> delegate;

- (void)setLeftProduct:(Product *)product;
- (void)setLeftProductIndex:(NSUInteger)index;
- (void)setRightProduct:(Product *)product;
- (void)setRightProductIndex:(NSUInteger)index;

@end
