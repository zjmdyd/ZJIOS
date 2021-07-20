//
//  ZJTextInputConfig.m
//  ZJIOS
//
//  Created by issuser on 2021/7/19.
//

#import "ZJTextInputConfig.h"

@implementation ZJTextInputConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tag = 0;
        self.textAlignment = NSTextAlignmentLeft;
        self.keyboardType = UIKeyboardTypeDefault;
    }
    return self;
}
@end
