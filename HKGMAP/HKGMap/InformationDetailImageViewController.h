//
//  InformationDetailImageViewController.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-6.
//
//

#import <UIKit/UIKit.h>
#import "DiscountGallery.h"

@interface InformationDetailImageViewController : UIViewController

@property (nonatomic, retain) DiscountGallery *discountGallery;

- (id)initWithDataObject:(id)dataObject;

@end
