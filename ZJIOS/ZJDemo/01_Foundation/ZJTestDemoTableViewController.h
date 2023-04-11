//
//  ZJTestDemoTableViewController.h
//  ZJIOS
//
//  Created by issuser on 2023/4/11.
//

#import "ZJTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DidSelectedEventType) {
    DidSelectedEventTypeExecuteFunc,
    DidSelectedEventTypeShowPage,
};

@interface ZJTestDemoTableViewController : ZJTableViewController

@property (nonatomic, assign) DidSelectedEventType eventType;

@end

NS_ASSUME_NONNULL_END
