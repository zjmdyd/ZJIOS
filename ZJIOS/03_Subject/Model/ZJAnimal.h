//
//  ZJAnimal.h
//  ZJIOS
//
//  Created by Zengjian on 2021/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Block)(NSString *str);

@interface ZJAnimal : NSObject

- (instancetype)initWithBlock:(Block)block;
- (void)Block:(Block)block;
- (void)execute;
- (void)jump;
- (void)fly;
@end

NS_ASSUME_NONNULL_END
