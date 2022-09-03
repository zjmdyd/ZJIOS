//
//  NSObject+ZJObject.h
//  ZJIOS
//
//  Created by issuser on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZJObject)

- (NSString *)jsonString;

- (NSString *)descriptionText;
- (NSString *)descriptionTextWithDefault:(NSString *)defaultText;

@end

NS_ASSUME_NONNULL_END
