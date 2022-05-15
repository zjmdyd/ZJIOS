//
//  ZJDateFormatter.h
//  ZJIOS
//
//  Created by issuser on 2021/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZJDateFormatStyle) {
    ZJDateFormatStyleFull,              // yyyy-MM-dd HH:mm:ss
    ZJDateFormatStyleMedium,            // yyyy-M-d HH:mm:ss
    ZJDateFormatStyleShort,             // yyyy-M-d H:m:s
    ZJDateFormatStyleFull_12Hours,      // yyyy-MM-dd hh:mm:ss
    ZJDateFormatStyleMedium_12Hours,    // yyyy-M-d hh:mm:ss
    ZJDateFormatStyleShort_12Hours,     // yyyy-M-d h:m:s
};

@interface ZJDateFormatter : NSDateFormatter

- (NSString *)dateFormatStringWithStyle:(ZJDateFormatStyle)style;

@end

NS_ASSUME_NONNULL_END
