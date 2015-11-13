//
//  ProductListViewController.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import <UIKit/UIKit.h>
#import "ProductListCell.h"

@interface ProductListViewController : UITableViewController<ProductListCellDelegate>

- (id)initWithDataObject:(id)dataObject;

@end
