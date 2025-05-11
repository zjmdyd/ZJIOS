//
//  ZJAnchorPointViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/6/12.
//

#import "ZJAnchorPointViewController.h"

@interface ZJAnchorPointViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *moveView;

@end

@implementation ZJAnchorPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self test0];
    [self test1];
}
/*
 2025-05-10 23:28:50.443553+0800 ZJIOS[75098:2934913] anchorPoint = {0.5, 0.5}
 2025-05-10 23:28:50.443804+0800 ZJIOS[75098:2934913] bgView_position = {187.5, 333.5}
 2025-05-10 23:28:50.444004+0800 ZJIOS[75098:2934913] frame = {{37.5, 183.5}, {300, 300}}
 2025-05-10 23:28:50.444164+0800 ZJIOS[75098:2934913] p(x, y) = (187.500000, 333.500000)
 2025-05-10 23:28:50.444331+0800 ZJIOS[75098:2934913] center = {187.5, 333.5}
 */
- (void)test0 {
    NSLog(@"anchorPoint = %@", NSStringFromCGPoint(self.bgView.layer.anchorPoint));
    NSLog(@"bgView_position = %@", NSStringFromCGPoint(self.bgView.layer.position));
    NSLog(@"frame = %@", NSStringFromCGRect(self.bgView.frame));
    CGFloat p_x = self.bgView.frame.origin.x + self.bgView.frame.size.width/2;
    CGFloat p_y = self.bgView.frame.origin.y + self.bgView.frame.size.height/2;
    NSLog(@"p(x, y) = (%f, %f)", p_x, p_y);
    NSLog(@"center = %@", NSStringFromCGPoint(self.bgView.center));
}
/*
 2025-05-10 23:28:50.444492+0800 ZJIOS[75098:2934913] moveView_anchorPoint = {0.5, 0.5}
 2025-05-10 23:28:50.444641+0800 ZJIOS[75098:2934913] moveView_position = {225, 150}
 2025-05-10 23:28:50.444862+0800 ZJIOS[75098:2934913] moveView_anchorPoint = {0, 0.5}
 2025-05-10 23:28:50.445024+0800 ZJIOS[75098:2934913] moveView_position = {150, 150}
 */
- (void)test1 {
    NSLog(@"moveView_anchorPoint = %@", NSStringFromCGPoint(self.moveView.layer.anchorPoint));
    NSLog(@"moveView_position = %@", NSStringFromCGPoint(self.moveView.layer.position));

    self.moveView.layer.anchorPoint = CGPointMake(0, 0.5);
//    The value of this property is specified in points and is always specified relative to the value in the anchorPoint property
//    self.moveView.layer.position = CGPointMake(150, 150); // 修改无效，与锚点相关联

    NSLog(@"moveView_anchorPoint = %@", NSStringFromCGPoint(self.moveView.layer.anchorPoint));
    NSLog(@"moveView_position = %@", NSStringFromCGPoint(self.moveView.layer.position));
    
    [UIView animateWithDuration:2 animations:^{
        self.moveView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }];
}

- (void)test2 {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 150, 200, 30)];
    [self.view addSubview:view1];
    view1.backgroundColor = [UIColor redColor];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(100, 150, 200, 30)];
    view2.layer.anchorPoint = CGPointMake(0, 0.5);
    view2.layer.position = CGPointMake(100, 165);
    [self.view addSubview:view2];
    view2.backgroundColor = [UIColor greenColor];
    [UIView animateWithDuration:2 animations:^{
        view2.transform = CGAffineTransformMakeRotation(M_PI_2);
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __func__);
    NSLog(@"moveView_position = %@", NSStringFromCGPoint(self.moveView.layer.position));
//    self.moveView.layer.position = CGPointMake(150, 150);
}

/*
 约束会导致之前设置的position无效
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSLog(@"%s", __func__);
    NSLog(@"moveView_position = %@", NSStringFromCGPoint(self.moveView.layer.position));
//    self.moveView.layer.position = CGPointMake(150, 150);

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
