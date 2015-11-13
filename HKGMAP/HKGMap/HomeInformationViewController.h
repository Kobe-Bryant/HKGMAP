//
//  HomeInformationViewController.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-3.
//
//

#import <UIKit/UIKit.h>

@protocol HomeInformationViewControllerDelegate <NSObject>

@optional
- (void)resetFrameHeight:(UIViewController *)currentController height:(CGFloat)height;

@end



@interface HomeInformationViewController : UIViewController

@property (nonatomic, assign) id<HomeInformationViewControllerDelegate> delegate;

- (id)initWithDataObject:(id)dataObject;

@end
