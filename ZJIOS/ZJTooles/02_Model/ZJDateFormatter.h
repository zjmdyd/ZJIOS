//
//  ZJDateFormatter.h
//  ZJIOS
//
//  Created by issuser on 2021/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZJDateFormatStyle) {
    ZJDateFormatFullStyle,       // yyyy-MM-dd HH:mm:ss
    ZJDateFormatMediumStyle,     // yyyy-M-d HH:mm:ss
    ZJDateFormatShortStyle,      // yyyy-M-d H:m:s
};

@interface ZJDateFormatter : NSDateFormatter

- (NSString *)dateFormatStringWithStyle:(ZJDateFormatStyle)style;

@end

NS_ASSUME_NONNULL_END
