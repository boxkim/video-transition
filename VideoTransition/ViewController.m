//
//  ViewController.m
//  VideoTransition
//
//  Created by JinPeng on 16/12/9.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import "ViewController.h"
#import "IMVideoTransitionView.h"

@interface ViewController () <IMVideoTransitionDelegate>

// 视频转场视图
@property (nonatomic, strong) IMVideoTransitionView *videoTransitionView;
// 遮罩层
@property (nonatomic, strong) UIImageView *maskImageView;

@property (nonatomic, strong) UIButton *zoomInBtn;

@property (nonatomic, strong) UIButton *zoomOutBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self loadMaskImageWithName:@"scene1.jpg"];
    [self.zoomInBtn setHidden:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)zoomInBtn {
    if (!_zoomInBtn) {
        _zoomInBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 100, 40)];
        _zoomInBtn.hidden = YES;
        [_zoomInBtn setTitle:@"镜头拉近" forState:UIControlStateNormal];
        [_zoomInBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_zoomInBtn addTarget:self action:@selector(zoomIn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_zoomInBtn];
    }
    return _zoomInBtn;
}

- (void)zoomIn:(id)sender {
    [self playVideoWithName:@"video1.mp4" withIndex:1];
}

- (UIButton *)zoomOutBtn {
    if (!_zoomOutBtn) {
        _zoomOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 100, 40)];
        _zoomOutBtn.hidden = YES;
        [_zoomOutBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_zoomOutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_zoomOutBtn addTarget:self action:@selector(zoomOut:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_zoomOutBtn];
    }
    return _zoomOutBtn;
}

- (void)zoomOut:(id)sender {
    [self playVideoWithName:@"video2.mp4" withIndex:2];
}


#pragma mark - IMVideoTransitionDelegate

- (void)videoTransitionView:(IMVideoTransitionView *)transitionView playerDidFinishAtIndex:(NSInteger)index {
    if (index == 1) {
        [self loadMaskImageWithName:@"scene2.jpg"];
        [self.zoomOutBtn setHidden:NO];
        [self.zoomInBtn setHidden:YES];
    }
    else if (index == 2) {
        [self loadMaskImageWithName:@"scene1.jpg"];
        [self.zoomInBtn setHidden:NO];
        [self.zoomOutBtn setHidden:YES];
    }
}

#pragma mark - mask image view

// 遮罩层有两个作用
// 1、掩盖视频加载时候的黑屏现象
// 2、视频播放完成之后的场景显示
- (void)loadMaskImageWithName:(NSString *)imageName {
    if (!_maskImageView) {
        self.maskImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.maskImageView setUserInteractionEnabled:YES];
        [self.view addSubview:self.maskImageView];
    }
    [self.maskImageView setImage:[UIImage imageNamed:imageName]];
    [self.view bringSubviewToFront:self.maskImageView];
}

#pragma mark - play video

// 这里为了方便，每次播放视频都重新初始化一个播放器
// index 参数只是一个标识符，可以用任何便于识别的数据类型
- (void)playVideoWithName:(NSString *)videoFile withIndex:(NSInteger)index {
    if (_videoTransitionView) {
        _videoTransitionView.delegate = nil;
        [_videoTransitionView.moviePlayer stop];
        [_videoTransitionView removeFromSuperview];
        _videoTransitionView = nil;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:videoFile ofType:nil];
    self.videoTransitionView = [[IMVideoTransitionView alloc] initWithFrame:self.view.bounds
                                                                    withUrl:[NSURL fileURLWithPath:path]];
    self.videoTransitionView.index = index;
    self.videoTransitionView.delegate = self;
    [self.view addSubview:self.videoTransitionView];
    
    // 这里因为视频加载是需要时间的，加载过程中播放器呈黑色，如果不加遮罩会出现闪屏现象
    // 0.2 秒是个预估值，正规点是需要监听视频加载完成消息的，如果有闪屏现象可以适当的加长这个时间，但是不宜太长。
    // 在视频开始加载的时候先将遮罩层放在视频上面，等视频加载完成开始播放的时候将视频放到上面
    typeof(self) weakSelf = self;
    [self.view bringSubviewToFront:self.maskImageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.view bringSubviewToFront:weakSelf.videoTransitionView];
    });
}


@end
