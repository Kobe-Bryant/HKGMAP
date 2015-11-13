//
//  ProductDetailImageViewController.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import <UIKit/UIKit.h>
#import "ProductGallery.h"

@interface ProductDetailImageViewController : UIViewController

@property (nonatomic, retain) ProductGallery *productGallery;

- (id)initWithDataObject:(ProductGallery *)productGallery;

@end
