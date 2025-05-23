//
//  ZJUIAttachmentBehaviorViewController.m
//  ZJUIKit
//
//  Created by YunTu on 15/9/7.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJUIAttachmentBehaviorViewController.h"

@interface ZJUIAttachmentBehaviorViewController ()<UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;

@end

@implementation ZJUIAttachmentBehaviorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = @[@"attachmentBehavior", @"attachment+collisionBehavior"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 80 + 45*i, 250, 35)];
        btn.backgroundColor = [UIColor blueColor];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(attachmentBehaviorAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleAttachmentGesture:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)attachmentBehaviorAction:(UIButton *)sender {
    if (self.animationView.superview) {
        [self.animationView removeFromSuperview];
        self.animator = nil;
    }
    self.animationView = [[UIView alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
    self.animationView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.animationView];
    self.animationView.transform = CGAffineTransformRotate(self.animationView.transform, 45);
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];    //此处不能用局部变量，否则出了作用域，animator被ARC释放，动画效果失效
    
    // gravityBehavior
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.animationView]];
    
    if (sender.tag == 1) {      // attachmentBehavior + collisionBehavior
        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.animationView]];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        collisionBehavior.collisionDelegate = self;
        [self.animator addBehavior:collisionBehavior];
    }
}

- (void)handleAttachmentGesture:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self.animator addBehavior:self.gravityBehavior];
        
        // attachmentBehavior
        CGPoint point = CGPointMake(self.animationView.center.x, self.animationView.center.y - 100);
        self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.animationView attachedToAnchor:point];
        [self.animator addBehavior:self.attachmentBehavior];
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        [self.attachmentBehavior setAnchorPoint:[panGesture locationInView:self.view]];
    }else if (panGesture.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachmentBehavior];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
