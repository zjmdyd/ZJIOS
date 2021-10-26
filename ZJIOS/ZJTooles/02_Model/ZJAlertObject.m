//
//  ZJAlertObject.m
//  KeerZhineng
//
//  Created by ZJ on 2019/2/19.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJAlertObject.h"

@implementation ZJAlertObject

- (instancetype)init {
    self = [super init];
    if (self) {
        // 当needCancel为YES时，默认第一个item为cancel
        self.needCancel = YES;
        self.cancelIndex = 0;
        self.actTitles = @[@"取消", @"确定"];
        self.alertStyle = UIAlertControllerStyleAlert;
    }
    
    return self;
}

- (BOOL)needSetTitleColor {
    return self.actTitles.count == self.actTitleColors.count;
}

@end
