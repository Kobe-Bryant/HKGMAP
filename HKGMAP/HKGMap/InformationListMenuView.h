//
//  InformationListMenuView.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-20.
//
//

#import <UIKit/UIKit.h>

@protocol InformationListMenuViewDelegate <NSObject>

@optional
- (void)switchDiscountCategoryIndex:(NSInteger)selectedIndex;

@end


@interface InformationListMenuView : UIScrollView

@property (nonatomic, assign) id<InformationListMenuViewDelegate> menuDelegate;

- (id)initWithDataObject:(id)dataObject;
- (void)tapDiscountCategory:(NSNumber *)discountCategoryID;

@end
