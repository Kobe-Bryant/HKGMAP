//
//  MerchantMapFilterViewController.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-8.
//
//

#import <UIKit/UIKit.h>


@protocol MerchantFilterViewControllerDelegate <NSObject>

@optional
- (void)showFilterSubmenu;
- (void)hideFilterSubmenu;
- (void)didSelectNearbyRadius:(CGFloat)nearbyRadius;
- (void)didSelectBusinessDistrictID:(NSNumber *)businessDistrictID;
- (void)didSelectMerchantTypeID:(NSNumber *)merchantTypeID;

@end


@interface MerchantFilterViewController : UIViewController

@property (nonatomic, assign) id<MerchantFilterViewControllerDelegate> delegate;

- (id)initWithDataObject:(NSArray *)businessDistrictArray merchantTypeArray:(NSArray *)merchantTypeArray;

@end
