//
//  NSObject+Telen.m
//  KidReading
//
//  Created by telen on 15/7/20.
//  Copyright (c) 2015年 Creative Knowledge Ltd. All rights reserved.
//

#import "NSObject+Telen.h"
#import "TLCFunction.h"

@implementation NSObject (Telen)

+ (NSDictionary *)properties_attributes_toOriginAttrString:(BOOL)yn {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        NSString *attribute = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        if (yn) {
            if (attribute) [props setObject:attribute forKey:propertyName];
        }else{
            if ([attribute hasPrefix:@"T@"]) {
                NSArray* arr = [attribute componentsSeparatedByString:@"\""];
                NSString* att = arr[1];
                [props setObject:att forKey:propertyName];
            }else if([attribute hasPrefix:@"Ti"]){
                [props setObject:@"NSInteger" forKey:propertyName];
            }else if([attribute hasPrefix:@"Tc"]){
                [props setObject:@"BOOL" forKey:propertyName];
            }else if([attribute hasPrefix:@"Tf"]){
                [props setObject:@"float" forKey:propertyName];
            }else if([attribute hasPrefix:@"Td"]){
                [props setObject:@"double" forKey:propertyName];
            }else if([attribute hasPrefix:@"Tl"]){
                [props setObject:@"long" forKey:propertyName];
            }else if([attribute hasPrefix:@"Tq"]){
                [props setObject:@"long long" forKey:propertyName];
            }else if([attribute hasPrefix:@"TI"]){
                [props setObject:@"NSUInteger" forKey:propertyName];
            }else if([attribute hasPrefix:@"T*"]){
                [props setObject:@"char*" forKey:propertyName];
            }else if([attribute hasPrefix:@"T^v"]){
                [props setObject:@"void*" forKey:propertyName];
            }
        }
    }
    free(properties);
    return props;
}

- (NSDictionary *)properties_value_class:(Class)clss {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(clss, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

- (NSDictionary *)properties_value {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

- (NSDictionary *)properties_value_description {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
        else [props setObject:@"" forKey:propertyName];
    }
    free(properties);
    return props;
}

- (BOOL)hasProperty:(NSString*)name
{
    if (name != nil) {
        objc_property_t property = class_getProperty([self class], name.UTF8String);
        if (property != nil
            && property != NULL) {
            return YES;
        }
    }
    return NO;
}

- (void)copy_properties_value_fromClass:(Class)clss to:(id)obj
{
    if (obj && [obj isKindOfClass:clss]) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(clss, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
            id propertyValue = [self valueForKey:(NSString *)propertyName];
            [obj setValue:propertyValue forKey:propertyName];
        }
        free(properties);
    }
}

@end

@implementation NSObject (Debug)

- (NSInteger)getRetainCount
{
    return  CFGetRetainCount((__bridge CFTypeRef)self);
}

@end


@implementation NSObject (TLRunTime)

+ (void)swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethodInit=class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethodInit) {
        class_addMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzleClassSelector:(SEL)originalSelector withClassSelector:(SEL)swizzledSelector {
    Class class = [self class];
    
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    if ((int)originalMethod != 0 && (int)swizzledMethod != 0) {
         method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (IMP)getImplementationSelector:(SEL)originalSelector
{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    return method_getImplementation(originalMethod);
}

+ (id)msgToTarget:(id)target menthed:(NSString *)menthed refs:(NSArray*)refArr needReturnValue:(BOOL)retNeed{
    return tl_oc_msgToTarget(target,menthed,refArr,retNeed);
}
- (id)msgTo_menthed:(NSString *)menthed refs:(NSArray *)refArr needReturnValue:(BOOL)retNeed{
    return tl_oc_msgToTarget((id)self,menthed,refArr,retNeed);
}

+ (id)msgToTarget:(id)target getmenthed:(NSString *)getmenthed domenthed:(NSString *)menthed refs:(NSArray*)refArr needReturnValue:(BOOL)retNeed{
    id getTarget = [self msgToTarget:target menthed:getmenthed refs:nil needReturnValue:YES];
    return [self msgToTarget:getTarget menthed:menthed refs:refArr needReturnValue:retNeed];
}
- (id)msgTo_getmenthed:(NSString *)getmenthed domenthed:(NSString *)menthed refs:(NSArray *)refArr needReturnValue:(BOOL)retNeed{
    return [NSObject msgToTarget:(id)self getmenthed:getmenthed domenthed:menthed refs:refArr needReturnValue:retNeed];
}

//类方法
+ (id)msgToClassName:(NSString *)className menthed:(NSString *)menthed refs:(NSArray*)refArr needReturnValue:(BOOL)retNeed{
    return tl_oc_msgToClass(className,menthed,refArr,retNeed);
}

@end


#ifndef NULLSAFE_ENABLED
#define NULLSAFE_ENABLED 1
#endif
#pragma GCC diagnostic ignored "-Wgnu-conditional-omitted-operand"
@implementation NSNull (NullSafe)

#if NULLSAFE_ENABLED

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    @synchronized([self class])
    {
        //look up method signature
        NSMethodSignature *signature = [super methodSignatureForSelector:selector];
        if (!signature)
        {
            //not supported by NSNull, search other classes
            static NSMutableSet *classList = nil;
            static NSMutableDictionary *signatureCache = nil;
            if (signatureCache == nil)
            {
                classList = [[NSMutableSet alloc] init];
                signatureCache = [[NSMutableDictionary alloc] init];
                
                //get class list
                int numClasses = objc_getClassList(NULL, 0);
                Class *classes = (Class *)malloc(sizeof(Class) * (unsigned long)numClasses);
                numClasses = objc_getClassList(classes, numClasses);
                
                //add to list for checking
                NSMutableSet *excluded = [NSMutableSet set];
                for (int i = 0; i < numClasses; i++)
                {
                    //determine if class has a superclass
                    Class someClass = classes[i];
                    Class superclass = class_getSuperclass(someClass);
                    while (superclass)
                    {
                        if (superclass == [NSObject class])
                        {
                            [classList addObject:someClass];
                            break;
                        }
                        [excluded addObject:NSStringFromClass(superclass)];
                        superclass = class_getSuperclass(superclass);
                    }
                }
                
                //remove all classes that have subclasses
                for (Class someClass in excluded)
                {
                    [classList removeObject:someClass];
                }
                
                //free class list
                free(classes);
            }
            
            //check implementation cache first
            NSString *selectorString = NSStringFromSelector(selector);
            signature = signatureCache[selectorString];
            if (!signature)
            {
                //find implementation
                for (Class someClass in classList)
                {
                    if ([someClass instancesRespondToSelector:selector])
                    {
                        signature = [someClass instanceMethodSignatureForSelector:selector];
                        break;
                    }
                }
                
                //cache for next time
                signatureCache[selectorString] = signature ?: [NSNull null];
            }
            else if ([signature isKindOfClass:[NSNull class]])
            {
                signature = nil;
            }
        }
        return signature;
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:nil];
}

#endif

@end


#pragma mark-
@implementation NSObject(UnMenthod)

+ (void)load
{
    [self swizzleSelector:@selector(methodSignatureForSelector:) withSelector:@selector(methodSignatureForSelector_un:)];
    [self swizzleSelector:@selector(forwardInvocation:) withSelector:@selector(forwardInvocation_un:)];
}

- (id)undo_undo{return nil;}

- (NSMethodSignature *)methodSignatureForSelector_un:(SEL)selector
{
    @synchronized([self class])
    {
        //look up method signature
        NSMethodSignature *signature = [self methodSignatureForSelector_un:selector];
        if (!signature)
        {
            NSArray<NSString*>* symbols = [NSThread callStackSymbols];
            if (symbols.count >= 3) {
                NSString* str1 = symbols[1];
                NSString* str2 = symbols[2];
                NSRange r1 = [str1 rangeOfString:@"CoreFoundation"];
                NSRange r2 = [str2 rangeOfString:@"CoreFoundation"];
                NSRange r21 = [str2 rangeOfString:@"forwarding"];
                if (r1.location != NSNotFound && r2.location != NSNotFound && r21.location != NSNotFound) {
                    signature = [self methodSignatureForSelector_un:@selector(undo_undo)];
#ifdef DEBUG
                    NSLog(@"error: unselector to [%@ %@]",NSStringFromClass([self class]),NSStringFromSelector(selector));
#endif
                }
            }
        }
        return signature;
    }
}

// Invoke the invocation on whichever real object had a signature for it.
- (void)forwardInvocation_un:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:nil];
}

@end







