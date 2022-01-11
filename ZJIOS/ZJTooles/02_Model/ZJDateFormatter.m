//
//  ZJDateFormatter.m
//  ZJIOS
//
//  Created by issuser on 2021/12/27.
//

#import "ZJDateFormatter.h"

@interface ZJDateFormatter ()

@property (nonatomic, strong) NSArray *formatStyles;

@end

@implementation ZJDateFormatter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.formatStyles = @[@"yyyy-MM-dd HH:mm:ss", @"yyyy-M-d HH:mm:ss", @"yyyy-M-d H:m:s"];
    }
    
    return self;
}

/*
 [yyyy, MM, dd, HH, mm, ss]
 [yyyy, MM, dd, H,  m,  s]
 [yyyy, M,  d,  HH, m,  s]
 */

- (NSString *)dateFormatStringWithStyle:(ZJDateFormatStyle)style {
    return self.formatStyles[style];
}

@end
