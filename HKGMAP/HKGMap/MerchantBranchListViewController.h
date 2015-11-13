//
//  MerchantBranchListViewController.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-10.
//
//

#import <UIKit/UIKit.h>
#import "MerchantBranchListViewCell.h"

@interface MerchantBranchListViewController : UITableViewController<MerchantBranchListViewCellDelegate>

- (id)initWithDataObject:(id)dataObject;

@end
