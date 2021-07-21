//
//  NSString+URL.h
//  KidReading
//
//  Created by telen on 14/12/31.
//  Copyright (c) 2014年 Creative Knowledge Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (URL)
- (NSString *)URLEncodedString;
- (NSString *)URLEncodedString_2;
- (NSString *)URLDecodedString;

- (BOOL)isEmail;

- (NSDictionary*)dictionaryURLQueryUsingEncoding:(NSStringEncoding)encoding;
@end
