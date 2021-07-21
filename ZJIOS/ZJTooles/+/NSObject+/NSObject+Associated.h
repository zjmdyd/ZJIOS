//
//  NSObject+Assosiated.h
//  NSObject-Associated
//
//  Created by Konstantin Koval on 29/03/14.
//  Copyright (c) 2014 Konstantin Koval. All rights reserved.
//

/**
 * A macro that creates getter and setter for your assosiated object
 *
 * @param propertyName Getter funtion name
 * @param setter Setter funtion name
 * @param objc_AssociationPolicy Memory policy for assosiated object
 *
 * Available option: OBJC_ASSOCIATION_ASSIGN, OBJC_ASSOCIATION_RETAIN_NONATOMIC, OBJC_ASSOCIATION_COPY_NONATOMIC, OBJC_ASSOCIATION_RETAIN, OBJC_ASSOCIATION_COPY
 *
 */
#import <objc/runtime.h>
//MARK: id
#define ASSOCIATED(propertyName, setter, type, objc_AssociationPolicy)\
- (type)propertyName {\
return objc_getAssociatedObject(self, _cmd);\
}\
\
- (void)setter:(type)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), object, objc_AssociationPolicy);\
}

//MARK: BOOL
#define ASSOCIATED_BOOL(propertyName, setter)\
- (BOOL)propertyName {\
NSNumber *value = objc_getAssociatedObject(self, _cmd); return value.boolValue;\
}\
\
- (void)setter:(BOOL)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

//MARK: NSInteger
#define ASSOCIATED_NSInteger(propertyName, setter)\
- (NSInteger)propertyName {\
NSNumber *value = objc_getAssociatedObject(self, _cmd); return value.integerValue;\
}\
\
- (void)setter:(NSInteger)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

//MARK: float
#define ASSOCIATED_float(propertyName, setter)\
- (float)propertyName {\
NSNumber *value = objc_getAssociatedObject(self, _cmd); return value.floatValue;\
}\
\
- (void)setter:(float)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

//MARK: double
#define ASSOCIATED_double(propertyName, setter)\
- (double)propertyName {\
NSNumber *value = objc_getAssociatedObject(self, _cmd); return value.doubleValue;\
}\
\
- (void)setter:(double)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

//MARK: long long
#define ASSOCIATED_longlong(propertyName, setter)\
- (long long)propertyName {\
NSNumber *value = objc_getAssociatedObject(self, _cmd); return value.longLongValue;\
}\
\
- (void)setter:(long long)object\
{\
objc_setAssociatedObject(self, @selector(propertyName), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

//在类别中添加属性
//使用方法如下：
/**
 
 #import <Foundation/Foundation.h>
 
 @interface NSObject (AssociatedTest)
 
 @property (nonatomic, strong) NSString *name;
 @property (nonatomic, assign) id delegate;
 @property (nonatomic, assign) BOOL isOK;
 
 @end
 
 // Implementation
 #import "KKNSObject+Associated.h"
 
 @implementation NSObject (AssociatedTest)
 
 ASSOCIATED(name, setName, NSString *, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
 ASSOCIATED(delegate, setDelegate, id, OBJC_ASSOCIATION_ASSIGN)
 ASSOCIATED_BOOL(isOK, setIsOK)
 
 @end

*/