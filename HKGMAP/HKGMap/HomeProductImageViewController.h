//
//  HomeProductImageViewController.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-7.
//
//

#import <UIKit/UIKit.h>
#import "Banner.h"

@protocol HomeProductImageViewControllerDelegate <NSObject>

- (void)didSelectProduct:(NSNumber *)productID;

@end



@interface HomeProductImageViewController : UIViewController

@property (nonatomic, assign) id<HomeProductImageViewControllerDelegate> delegate;
@property (nonatomic, retain) Banner *banner;

- (id)initWithBanner:(Banner *)banner;

@end
