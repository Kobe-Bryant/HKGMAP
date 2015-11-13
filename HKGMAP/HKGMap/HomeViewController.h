//
//  HomeViewController.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-1-3.
//
//

#import <UIKit/UIKit.h>
#import "HomeInformationViewController.h"
#import "HomeResultMaskGestureRecognizer.h"

@interface HomeViewController : UIViewController<HomeInformationViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, HomeResultMaskGestureRecognizerDelegate>

@end
