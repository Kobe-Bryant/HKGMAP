//
//  MerchantIntroImageViewController.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import <UIKit/UIKit.h>
#import "MerchantGallery.h"

@interface MerchantIntroImageViewController : UIViewController

@property (nonatomic, retain) MerchantGallery *merchantGallery;

- (id)initWithDataObject:(id)dataObject;

@end
