//
//  HomeResultMaskGestureRecognizer.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-20.
//
//

#import <UIKit/UIKit.h>

@protocol HomeResultMaskGestureRecognizerDelegate <NSObject>

@optional
- (void)homeResultMaskEnded;

@end


@interface HomeResultMaskGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) id<HomeResultMaskGestureRecognizerDelegate> _delegate;

@end
