//
//  ZJString.m
//  ZJIOS
//
//  Created by Zengjian on 2025/5/14.
//

#import "ZJString.h"

/*
 最好不要去继承类簇
 
 在 Objective-C 中继承类簇（如 NSString、NSArray 等）需谨慎处理，因其内部采用 ‌抽象工厂模式‌，实际实例由私有子类生成。以下是继承类簇的可行方案及注意事项：

 一、直接继承类簇的限制
 类簇（如 NSString）对外暴露公共接口，但具体实现由内部私有类（如 __NSCFString 等）完成。直接继承时可能出现以下问题5：

 ‌‌初始化方法未正确调用‌：系统可能返回私有子类实例而非自定义子类。
 ‌‌基础方法未覆盖‌：若未重写 length、characterAtIndex: 等原始方法（primitive methods），子类会崩溃。
 */
@interface ZJString () {
    NSData *_backingData;
}

@end

@implementation ZJString

// 必须重写原始方法
- (NSUInteger)length {
    return _backingData.length;
}

- (unichar)characterAtIndex:(NSUInteger)index {
    return ((const char *)_backingData.bytes)[index];
}

// 自定义初始化方法
- (instancetype)initWithData:(NSData *)data {
    if (self = [super init]) {
        _backingData = [data copy];
    }
    return self;
}

// 覆盖其他便捷初始化方法（如 init、initWithCString: 等）
- (instancetype)init {
    return [self initWithData:[NSData data]];
}

@end
