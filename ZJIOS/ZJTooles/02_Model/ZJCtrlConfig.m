//
//  ZJCtrlConfig.m
//  ZJIOS
//
//  Created by issuser on 2021/11/20.
//

#import "ZJCtrlConfig.h"

@implementation ZJCtrlConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hiddenBottom = YES;
        self.isGroup = YES;
    }
    return self;
}
@end
