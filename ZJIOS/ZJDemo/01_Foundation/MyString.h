//
//  MyString.h
//  ZJIOS
//
//  Created by Zengjian on 2025/5/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyString : NSString {
    NSData *_backingData;
}

- (instancetype)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
