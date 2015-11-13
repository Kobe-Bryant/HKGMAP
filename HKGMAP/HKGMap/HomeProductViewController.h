//
//  HomeProductViewController.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-3.
//
//

#import <UIKit/UIKit.h>
#import "HomeProductImageViewController.h"

@interface HomeProductViewController : UIViewController<UIPageViewControllerDelegate, UIPageViewControllerDataSource, HomeProductImageViewControllerDelegate>

- (id)initWithDataObject:(id)dataObject;

@end
