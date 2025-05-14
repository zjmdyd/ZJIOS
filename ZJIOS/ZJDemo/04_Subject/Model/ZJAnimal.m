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

-(void)jump {
    NSLog(@"%s", __func__);
}

- (void)fly {
    NSLog(@"我要飞的更高");
}

-(void)dealloc{
    NSLog(@"animal释放了");
}

@end
