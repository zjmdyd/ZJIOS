//
//  ZJParseObject.h
//  KeerZhineng
//
//  Created by ZJ on 2018/12/17.
//  Copyright © 2018 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ParseAssistantType) {
    ParseAssistantTypeOfDefault,
    ParseAssistantTypeOfHoustList,
    ParseAssistantTypeOfHoustDetail,
    ParseAssistantTypeOfSceneList,          // 场景列表
    ParseAssistantTypeOfSceneDeviceList,    // 场景设备列表
    ParseAssistantTypeOfHomeIndex,          //
    ParseAssistantTypeOfLockLog,            //
    ParseAssistantTypeOfBellLog,            //
    ParseAssistantTypeOfBellVideoLog,       //
    ParseAssistantTypeOfMessage,       //
};

NS_ASSUME_NONNULL_BEGIN

@interface ZJParseObject : NSObject

@property (nonatomic, copy) NSString *returnType;
@property (nonatomic, copy) id parseDataFlag;     // list等....
@property (nonatomic, copy) NSString *parseObjectType;  // model
@property (nonatomic, assign) BOOL isPageData;
@property (nonatomic, copy) NSString *parsePageDataFlag;
@property (nonatomic, copy) NSString *pageDataCountFlag;

// subData
@property (nonatomic, copy) NSString *parseSubObjectType;  // model
@property (nonatomic, copy) NSString *parseSubDataFlag;

@property (nonatomic, assign) ParseAssistantType assistDataType;

@end

NS_ASSUME_NONNULL_END
