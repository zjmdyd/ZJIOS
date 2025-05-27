//
//  ZJAVAudioPlayerViewController.m
//  ZJFoundation
//
//  Created by ZJ on 9/19/16.
//  Copyright © 2016 YunTu. All rights reserved.
//

#import "ZJAVAudioPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ZJAVAudioPlayerViewController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIImageView *iv;

@end

@implementation ZJAVAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSettiing];
}

- (void)initSettiing {
    [self.view addSubview:self.button];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.iv];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"my_song" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
        AVURLAsset *set = [AVURLAsset URLAssetWithURL:url options:nil];
        for (AVMetadataItem *item in set.commonMetadata) {
            if ([item.commonKey isEqualToString:@"artwork"]) {
                if ([item.value isKindOfClass:[NSData class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.iv.image = [UIImage imageWithData:(NSData *)item.value];
                    });
                }
                break;
            }
        }
        //    NSURL *url = [NSURL URLWithString:@"http://wl.baidu190.com/1474860041/20170927eb7c42da5df7f1320f0bafc0803a5d.mp3"];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //    self.player.numberOfLoops = 1;  // -1为无限循环, n为n+1次
        [self.player prepareToPlay];
        self.player.delegate = self;
        NSLog(@"duration = %f", self.player.duration);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.slider.maximumValue = self.player.duration;
        });
        
        // 启用会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *error;
        [session setActive:YES error:&error];
        if (error) {
            NSLog(@"setActive_error = %@", error);
        }
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    });
}

- (void)beganTimer {
    if (@available(iOS 10.0, *)) {
       self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull timer) {
//           NSLog(@"timer事件");
            self.slider.value = self.player.currentTime;
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)btnEvent:(UIButton *)sender {
    if (self.player.isPlaying) {
        [self.player pause];
    }else {
        [self.player play];
        self.slider.enabled = YES;
        [self beganTimer];
    }
    NSArray *titles = @[@"play", @"pause"];
    [sender setTitle:titles[self.player.isPlaying] forState:UIControlStateNormal];
}

- (void)sliderEvent:(UISlider *)sender {
    NSLog(@"%s, %f", __func__, sender.value);
    self.player.currentTime = sender.value;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"finish  : %d", flag);
    [self.timer invalidate];
    self.slider.enabled = NO;
    self.slider.value = 0;
    [self.button setTitle:@"play" forState:UIControlStateNormal];
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(0, 0, 100, 35);
        _button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [_button setTitle:@"play" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _button;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        _slider.center = CGPointMake(self.button.center.x, self.button.center.y - 60);
        _slider.enabled = NO;
        [_slider addTarget:self action:@selector(sliderEvent:) forControlEvents:UIControlEventValueChanged];
        
        //        _slider.continuous = NO;    // 设置 slider.continuous = NO 可使 ValueChanged 事件仅在拖动结束时触发
        // 监听用户手指抬起动作，适用于精确捕获滑动结束时刻
//        [_slider addTarget:self action:@selector(sliderEvent2:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _slider;
}

- (UIImageView *)iv {
    if (!_iv) {
        _iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        _iv.center = CGPointMake(self.slider.center.x, self.slider.center.y - 100);
    }
    return _iv;
}

//
//- (void)sliderEvent2:(UISlider *)sender {
//    NSLog(@"%s, %f", __func__, sender.value);
//    self.player.currentTime = sender.value;
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player stop];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 结束使用后停用（如录音完成后）
    [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];

    [self.timer invalidate];
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
