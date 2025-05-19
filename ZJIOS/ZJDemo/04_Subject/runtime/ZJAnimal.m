//
//  ZJAnimal.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/17.
//

#import "ZJAnimal.h"

@interface ZJAnimal ()

@property (nonatomic, copy) Block blk;

@end

@implementation ZJAnimal

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"self = %@, 初始化了", self);
    }
    return self;
}

- (instancetype)initWithBlock:(Block)block
{
    if (self = [super init]) {
        _blk = block;
    }
    return self;
}

- (void)Block:(Block)block
{
    _blk = block;
    NSLog(@"====%@",block);
}


- (void)execute
{
    _blk(@"block回调数据");
}

-(void)jump:(id)obj {
    NSLog(@"%s, %@", __func__, obj);
}

- (void)fly {
    NSLog(@"%s, %@", __func__, self);
}

-(void)dealloc{
    NSLog(@"animal释放了");
}

@end
