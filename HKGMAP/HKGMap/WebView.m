//
//  WebView.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-1.
//
//

#import "WebView.h"

@implementation WebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)loadHTMLStringWithCustomStyle:(NSString *)string baseURL:(NSURL *)baseURL
{
    NSString *contents = [[NSString alloc] init];
    contents = [contents stringByAppendingString:@"<style type=\"text/css\">\n"];
    contents = [contents stringByAppendingString:@"body { background-color: transparent; font-family: 黑体,Helvetica; font-size:13px; color: rgb(51, 51, 51); }\n"];
    contents = [contents stringByAppendingString:@"</style>\n"];
    contents = [contents stringByAppendingString:string];
    [self loadHTMLString:contents baseURL:baseURL];
}

@end
