//
//  WebView.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-1.
//
//

#import <UIKit/UIKit.h>

@interface WebView : UIWebView

- (void)loadHTMLStringWithCustomStyle:(NSString *)string baseURL:(NSURL *)baseURL;

@end
