//
//  NSObject+Telen.h
//  KidReading
//
//  Created by telen on 15/7/20.
//  Copyright (c) 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Telen)

+ (NSDictionary *)properties_attributes_toOriginAttrString:(BOOL)yn;
- (NSDictionary *)properties_value_class:(Class)clss;
- (NSDictionary *)properties_value;
- (NSDictionary *)properties_value_description;
- (BOOL)hasProperty:(NSString*)name;
//
- (void)copy_properties_value_fromClass:(Class)clss to:(id)obj;

@end


@interface NSObject (Debug)
- (NSInteger)getRetainCount;
@end


@interface NSObject (TLRunTime)
+ (void)swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector; //方便在+load 中替换成员方法
+ (void)swizzleClassSelector:(SEL)originalSelector withClassSelector:(SEL)swizzledSelector; //方便在+load 中替换类方法
+ (IMP)getImplementationSelector:(SEL)originalSelector;


//方法消息，安全转发，并获得返回值
+ (id)msgToTarget:(id)target menthed:(NSString *)menthed refs:(NSArray*)refArr needReturnValue:(BOOL)retNeed;
- (id)msgTo_menthed:(NSString *)menthed refs:(NSArray*)refArr needReturnValue:(BOOL)retNeed;

//安全属性获得二级target
+ (id)msgToTarget:(id)target getmenthed:(NSString *)getmenthed domenthed:(NSString *)menthed refs:(NSArray*)refArr needReturnValue:(BOOL)retNeed;
- (id)msgTo_getmenthed:(NSString *)getmenthed domenthed:(NSString *)menthed refs:(NSArray*)refArr needReturnValue:(BOOL)retNeed;

//安全 向类发送消息
+ (id)msgToClassName:(NSString *)className menthed:(NSString *)menthed refs:(NSArray*)refArr needReturnValue:(BOOL)retNeed;

@end


//对NSNull 做异常过滤
@interface NSNull (NullSafe)
@end


//对未实现的方法  安全放置crash
@interface NSObject (UnMenthod)
@end

