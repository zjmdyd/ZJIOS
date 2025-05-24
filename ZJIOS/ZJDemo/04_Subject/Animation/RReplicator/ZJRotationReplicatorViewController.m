//
//  ZJRotationReplicatorViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 9/26/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJRotationReplicatorViewController.h"
#import "UIViewExt.h"
#import "UIBarButtonItem+ZJBarButtonItem.h"
#import "UIView+ZJView.h"

@interface ZJRotationReplicatorViewController ()<CAAnimationDelegate, CALayerDelegate> {
    CABasicAnimation *_moveAnimation;
    CABasicAnimation *_fadeAnimation;

    CALayer *_barLayer;
    CALayer *_instanceLayer;
    
    CAReplicatorLayer *_replicatorLayer1;
    CAReplicatorLayer *_replicatorLayer;
}

@property (weak, nonatomic) IBOutlet UIView *replicatorLayerView;
@property (strong, nonatomic)  UIView *rightItemView;

@property (weak, nonatomic) IBOutlet UISlider *instanceDelaySlider;

@property (weak, nonatomic) IBOutlet UILabel *layerSizeSliderValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *instanceCountSliderValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *instanceDelaySliderValueLabel;

@end

static NSString *VOLUMBARANIMATION = @"volumBarAnimation";
static NSString *FADEANIMATION = @"fadeAnimation";

@implementation ZJRotationReplicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSettiing];
//    [self createVolumBars];
    [self activityIndicator];
}

- (void)initSettiing {
    self.rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 33)];
//    self.rightItemView.layer.borderWidth = 1;
    [self.rightItemView addTapGestureWithDelegate:nil target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barbuttonWithCustomView:self.rightItemView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification) name:@"enterForeground" object:nil];
}

- (void)tapEvent:(UITapGestureRecognizer *)sender {
    if (_barLayer.animationKeys.count) {
        [_barLayer removeAnimationForKey:VOLUMBARANIMATION];
    }else {
        [_barLayer addAnimation:_moveAnimation forKey:VOLUMBARANIMATION];
    }
}

// 播放音乐动态按钮
- (void)createVolumBars {
    _replicatorLayer1 = [CAReplicatorLayer layer];
    _replicatorLayer1.frame = self.rightItemView.bounds;
    /*
     确切地说，position是layer中的anchorPoint点在superLayer中的位置坐标。因此可以说, position点是相对suerLayer的，anchorPoint点是相对layer的，两者是相对不同的坐标空间的一个重合点。
     再来看看position的原始定义:The layer’s position in its superlayer’s coordinate space。 中文可以理解成为position是layer相对superLayer坐标空间的位置，很显然，这里的位置是根据anchorPoint来确定的.
     */
//    NSLog(@"position = %@", NSStringFromCGPoint(replicatorLayer.position));
    _replicatorLayer1.position = CGPointMake(self.rightItemView.width/2 + 30, self.rightItemView.center.y);
//    NSLog(@"position = %@", NSStringFromCGPoint(replicatorLayer.position)); // {65, 16.5}

    _replicatorLayer1.instanceCount = 3;      // The number of copies to create
    _replicatorLayer1.instanceDelay = 0.33;   // instanceDelay is the temporal offset between each copy that the replicator layer renders
    _replicatorLayer1.masksToBounds = YES;
//    replicatorLayer.borderWidth = 1;
//    replicatorLayer.borderColor = [UIColor greenColor].CGColor;
    // 复制图层在被创建时产生的和上一个复制图层的位移
    _replicatorLayer1.instanceTransform = CATransform3DMakeTranslation(15.0, 0.0, 0.0);
    [self.rightItemView.layer addSublayer:_replicatorLayer1];
    
    _barLayer = [CALayer layer];
    _barLayer.bounds = CGRectMake(0, 0, 8, 33);
//    NSLog(@"anchorPoint = %@", NSStringFromCGPoint(_barLayer.anchorPoint));
//    NSLog(@"frame = %@", NSStringFromCGRect(_barLayer.frame));
//    NSLog(@"position = %@", NSStringFromCGPoint(_barLayer.position));
    _barLayer.position = CGPointMake(8, 43);
    _barLayer.backgroundColor = [UIColor redColor].CGColor;
    [_replicatorLayer1 addSublayer:_barLayer];  // replicatorLayer的每份拷贝都会添加此layer及layer的动画

    //
    _moveAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    _moveAnimation.toValue = @(_barLayer.position.y - 25);
    _moveAnimation.duration = 0.5;
    _moveAnimation.autoreverses = YES;   // 循环往返 : This will make the bar repeatedly move up and down
    _moveAnimation.repeatCount = MAXFLOAT;
    [_barLayer addAnimation:_moveAnimation forKey:VOLUMBARANIMATION];
}

- (void)activityIndicator {
    // 1
    _replicatorLayer = [CAReplicatorLayer layer]; //
    _replicatorLayer.frame = self.replicatorLayerView.bounds;
    
    // 2
    _replicatorLayer.instanceCount = 30;                            // The number of copies to create, including the source layers.
    _replicatorLayer.instanceDelay = (CFTimeInterval)(1/30.0);      // Specifies the delay, in seconds, between replicated copies. Animatable.
    _replicatorLayer.preservesDepth = NO;                           // 设图层为2D
    _replicatorLayer.instanceColor = [UIColor whiteColor].CGColor;  // source color component:red:1 green:1 blue:1 alpha:1, 实例开始颜色为白色
    
    //
    self.instanceDelaySlider.value = _replicatorLayer.instanceDelay;
    self.instanceCountSliderValueLabel.text = [NSString stringWithFormat:@"%ld", (long)_replicatorLayer.instanceCount];
    self.instanceDelaySliderValueLabel.text = [NSString stringWithFormat:@"%.2f", _replicatorLayer.instanceDelay];
    
    // 3, 可以不要第三步，但初始原色要设成白色
    _replicatorLayer.instanceRedOffset = 0.0;    // Defines the offset added to the red component of the color for each replicated instance
    _replicatorLayer.instanceGreenOffset = -0.5;
    _replicatorLayer.instanceBlueOffset = -0.5;
    _replicatorLayer.instanceAlphaOffset = 0.0;  // end color component: red:1 green:0.5 blue:0.5 alpha:1.0 462907284,在与偏差色共同作用下的颜色
    __weak typeof(self) weakSelf = self;

    // 4
    CGFloat angle = (M_PI * 2.0) / 29;
    _replicatorLayer.instanceTransform = CATransform3DRotate(_replicatorLayer.transform, angle, 0.0, 0.0, 1.0); //  z轴旋转
    [weakSelf.replicatorLayerView.layer addSublayer:_replicatorLayer];

    // 5
    _instanceLayer = [CALayer layer];
    _instanceLayer.frame = [self getAdjustInstanceLayerFrame:10];
    _instanceLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _instanceLayer.opacity = 0.0; // 0表示完全透明，1表示完全不透明）
    _instanceLayer.delegate = weakSelf;
    [_replicatorLayer addSublayer:_instanceLayer];
    self.layerSizeSliderValueLabel.text = @"10 x 30";
    
    // 6
    _fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    _fadeAnimation.fromValue = @0.0;
    _fadeAnimation.toValue = @1.0;  // （0表示完全透明，1表示完全不透明）
    _fadeAnimation.duration = 1;
    _fadeAnimation.repeatCount = MAXFLOAT;
    _fadeAnimation.delegate = weakSelf;
    
    // 7
    [_instanceLayer addAnimation:_fadeAnimation forKey:FADEANIMATION];
    
    /*
     创建一个CAReplicatorLayer实例，设框架为someView边界。
     设复制图层数instanceCount和绘制延迟，设图层为2D（preservesDepth = false），实例颜色为白色。
     为陆续的实例复件设置RGB颜色偏差值（默认为0，即所有复件保持颜色不变），不过这里实例初始颜色为白色，即RGB都为1.0，所以偏差值设红色为0，绿色和蓝色为相同负数会使其逐渐现出红色，alpha透明度偏差值的变化也与此类似，针对陆续的实例复件。
     创建旋转变换，使得实例复件按一个圆排列。
     创建供复制图层使用的实例图层，设置框架，使第一个实例在someView边界顶端水平中心处绘制，另外设置实例颜色，把实例图层添加到复制图层。
     创建一个透明度由1（不透明）过渡为0（透明）的淡出动画。
     设实例图层透明度为0，使得每个实例在绘制和改变颜色与alpha前保持透明。
     */
}

- (void)displayLayer:(CALayer *)layer {
    NSLog(@"%s", __func__);
}

/* If defined, called by the default implementation of -drawInContext: */

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    NSLog(@"%s", __func__);
}
/* If defined, called by the default implementation of the -display method.
 * Allows the delegate to configure any layer state affecting contents prior
 * to -drawLayer:InContext: such as `contentsFormat' and `opaque'. It will not
 * be called if the delegate implements -displayLayer. */

- (void)layerWillDraw:(CALayer *)layer{
//CA_AVAILABLE_STARTING (10.12, 10.0, 10.0, 3.0) {
    NSLog(@"%s", __func__);
}
/* Called by the default -layoutSublayers implementation before the layout
 * manager is checked. Note that if the delegate method is invoked, the
 * layout manager will be ignored. */

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    NSLog(@"%s", __func__);
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"%s", __func__);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"%s, flag = %d", __func__, flag);
    
}

- (CGRect)getAdjustInstanceLayerFrame:(CGFloat)value {
    CGRect frame = _instanceLayer.frame;
    CGFloat midX = CGRectGetMidX(self.replicatorLayerView.bounds) - value / 2.0;     // replicatorLayer顶部的那个copies
    frame.origin = CGPointMake(midX, 0);
    frame.size = CGSizeMake(value, value * 3);
    
    return frame;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    if (sender.tag == 0) {
        _instanceLayer.frame = [self getAdjustInstanceLayerFrame:sender.value];
        self.layerSizeSliderValueLabel.text = [NSString stringWithFormat:@"%.0f x %.0f", sender.value, sender.value*3];
    }else if (sender.tag == 1) {
        _replicatorLayer.instanceCount = (NSInteger)sender.value;
        CGFloat angle = (M_PI * 2) / (sender.value - 1);
        _replicatorLayer.instanceTransform = CATransform3DRotate(_replicatorLayer.transform, angle, 0.0, 0.0, 1.0);
//        _instanceLayer.frame = [self getAdjustInstanceLayerFrame:_instanceLayer.frame.size.width];
        self.instanceCountSliderValueLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
    }else if (sender.tag == 2) {
        _replicatorLayer.instanceDelay = (CFTimeInterval)sender.value;
        self.instanceDelaySliderValueLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
        if (sender.value < FLT_EPSILON) {
            _instanceLayer.opacity = 1.0;
            [_instanceLayer removeAnimationForKey:FADEANIMATION];
        }else {
            _fadeAnimation.duration = _replicatorLayer.instanceDelay * (_replicatorLayer.instanceCount - 1);
            _instanceLayer.opacity = 0.0;
            [_instanceLayer removeAnimationForKey:FADEANIMATION];
            [_instanceLayer addAnimation:_fadeAnimation forKey:FADEANIMATION];
        }
    }
}

- (CGFloat)getOffsetValueForSwitch:(UISwitch *)sender {
    if (sender.tag < 3) {
        return sender.isOn ? 0.0 : -0.5;
    }else {
        return sender.isOn ? -1.0 : 0.0;
    }
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    if (sender.tag ==  0) {
        _replicatorLayer.instanceRedOffset = [self getOffsetValueForSwitch:sender];
    }else if (sender.tag == 1) {
        _replicatorLayer.instanceGreenOffset = [self getOffsetValueForSwitch:sender];
    }else if (sender.tag == 2) {
        _replicatorLayer.instanceBlueOffset = [self getOffsetValueForSwitch:sender];
    }else if (sender.tag == 3) {
        _replicatorLayer.instanceAlphaOffset = [self getOffsetValueForSwitch:sender];
    }
}

- (void)handleNotification {
    [_barLayer addAnimation:_moveAnimation forKey:VOLUMBARANIMATION];
    [_instanceLayer addAnimation:_fadeAnimation forKey:FADEANIMATION];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _fadeAnimation.delegate = nil;  // 必须,不然不会释放

//    [_barLayer removeAnimationForKey:VOLUMBARANIMATION];
//    [_instanceLayer removeAnimationForKey:FADEANIMATION];
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
