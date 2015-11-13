//
//  InformationDetailMerchantListViewController.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-24.
//
//

#import <UIKit/UIKit.h>
#import "MerchantBranchListViewCell.h"

@interface InformationStoreListViewController : UITableViewController<MerchantBranchListViewCellDelegate>

- (id)initWithDataObject:(id)dataObject;

@end
