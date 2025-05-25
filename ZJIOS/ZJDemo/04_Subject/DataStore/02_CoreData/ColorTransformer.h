//
//  ColorTransformer.h
//  ZJIOS
//
//  Created by Zengjian on 2025/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorTransformer : NSValueTransformer

@end

NS_ASSUME_NONNULL_END
/*
 如果是非标准数据类型，如何保存？

 UIImage、UIColor
 UIImage和UIColor这类遵守了NSCoding协议的对象，Core Data会帮你转换为NSData后，保存，取回来，也会帮你从NSData转为相对应的对象。选择Transformable类型即可，

 数组，字典
 NSArray、NSMutableArray、NSDictionary、NSMutableDictionary也是遵守NSCoding的对象，也可以选择Transformable直接保存。

 当然，也可以选择Binary Data：

 保存前，调用NSKeyedUnarchiver的archivedDataWithRootObject:方法返回NSData类型数据，让Core Data可以对其进行保存；
 取回时，用NSKeyedUnarchiver的unarchiveObjectWithData:方法，将取回的NSData数据，转换回数组、字典对象。
 结构体
 保存结构体，可以选择Transformable类型。

 然后在声明属性类型的时候，使用NSValue类型，如@ property (nullable, nonatomic, retain) NSValue *imgeRect;

 赋值时，进行转化，如下：
  newUser.imgeRect = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 100.0, 100.0)];

 获取值的时候，再进行转换，如下：
  CGRect imageRect = [firstUser.imgeRect CGRectValue];
 */
