//
//  HomeResultMaskGestureRecognizer.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-20.
//
//

#import "HomeResultMaskGestureRecognizer.h"

@implementation HomeResultMaskGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self._delegate homeResultMaskEnded];
}

@end
