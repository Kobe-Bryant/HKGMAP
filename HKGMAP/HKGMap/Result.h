//
//  Result.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-25.
//
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property (nonatomic, readwrite) BOOL isSuccess;
@property (nonatomic, retain) id data;
@property (nonatomic, retain) NSError *error;

- (id)initWithSuccessData:(id)data;
- (id)initWithFailureError:(NSError *)error;

@end
