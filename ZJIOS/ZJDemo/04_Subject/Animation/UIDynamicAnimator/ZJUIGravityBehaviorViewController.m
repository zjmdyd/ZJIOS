//
//  ZJUIGravityBehaviorViewController.m
//  ZJUIKit
//
//  Created by YunTu on 15/9/6.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJUIGravityBehaviorViewController.h"
#import "GravityWithCollisionBehavior.h"

@interface ZJUIGravityBehaviorViewController ()<UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;

@end

@implementation ZJUIGravityBehaviorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = @[@"gravityBehavior", @"gravity+collisionBehavior"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 80 + 45*i, 250, 35)];
        btn.backgroundColor = [UIColor blueColor];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gravityBehaviorAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)gravityBehaviorAction:(UIButton *)sender {
    if (self.animationView.superview) {
        [self.animationView removeFromSuperview];
        self.animator = nil;
    }
    self.animationView = [[UIView alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
    self.animationView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.animationView];
    self.animationView.transform = CGAffineTransformRotate(self.animationView.transform, 45);
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];    //此处不能用局部变量，否则出了作用域，animator被ARC释放，动画效果失效
    
    /* 自定义Behavior组合创建 */
    /*
    if (sender.tag == 1) {
        GravityWithCollisionBehavior *behavior = [[GravityWithCollisionBehavior alloc] initWithItem:@[self.animationView]];
        [self.animator addBehavior:behavior];
        
        return;
    }
     */
    
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.animationView]];
    [self.animator addBehavior:self.gravityBehavior];
    
    // gravityBehavior + collisionBehavior
    if (sender.tag == 1) {
        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.animationView]];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        collisionBehavior.collisionDelegate = self;
        [self.animator addBehavior:collisionBehavior];
    }
}

#pragma -mark collisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    NSLog(@"%@, %@", item, identifier);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 UIDynamicItem：用来描述一个力学物体的状态，其实就是实现了UIDynamicItem委托的对象，或者抽象为有面积有旋转的质点；
 UIDynamicBehavior：动力行为的描述，用来指定UIDynamicItem应该如何运动，即定义适用的物理规则。一般我们使用这个类的子类对象来对一组UIDynamicItem应该遵守的行为规则进行描述；
 UIDynamicAnimator；动画的播放者，动力行为（UIDynamicBehavior）的容器，添加到容器内的行为将发挥作用；
 ReferenceView：等同于力学参考系，如果你的初中物理不是语文老师教的话，我想你知道这是啥..只有当想要添加力学的UIView是ReferenceView的子view时，动力UI才发生作用。
 
 1. 以现在ViewController的view为参照系（ReferenceView），来初始化一个UIDynamicAnimator。
 2. 然后分配并初始化一个动力行为，这里是UIGravityBehavior，将需要进行物理模拟的UIDynamicItem传入。UIGravityBehavior的initWithItems:接受的参数为包含id的数组，另外UIGravityBehavior实例还有一个addItem:方法接受单个的id。就是说，实现了UIDynamicItem委托的对象，都可以看作是被力学特性影响的，进而参与到计算中。UIDynamicItem委托需要我们实现bounds，center和transform三个属性，在UIKit Dynamics计算新的位置时，需要向Behavior内的item询问这些参数，以进行正确计算。iOS7中，UIView和UICollectionViewLayoutAttributes已经默认实现了这个接口，所以这里我们直接把需要模拟重力的UIView添加到UIGravityBehavior里就行了。
 3. 把配置好的UIGravityBehavior添加到animator中。
 4. strong持有一下animator，避免当前scope结束被ARC释放掉（后果当然就是UIView在哪儿傻站着不掉
 
 ** UIAttachmentBehavior 描述一个view和一个锚相连接的情况，也可以描述view和view之间的连接。attachment描述的是两个点之间的连接情况，可以通过设置来模拟无形变或者弹性形变的情况（再次希望你还记得这些概念，简单说就是木棒连接和弹簧连接两个物体）。当然，在多个物体间设定多个；UIAttachmentBehavior，就可以模拟多物体连接了..有了这些，似乎可以做个老鹰捉小鸡的游戏了- -…
 ** UISnapBehavior 将UIView通过动画吸附到某个点上。初始化的时候设定一下UISnapBehavior的initWithItem:snapToPoint:就行，因为API非常简单，视觉效果也很棒，估计它是今后非游戏app里会被最常用的效果之一了；
 ** UIPushBehavior 可以为一个UIView施加一个力的作用，这个力可以是持续的，也可以只是一个冲量。当然我们可以指定力的大小，方向和作用点等等信息。
 ** UIDynamicItemBehavior 其实是一个辅助的行为，用来在item层级设定一些参数，比如item的摩擦，阻力，角阻力，弹性密度和可允许的旋转等等
 
 */

@end
