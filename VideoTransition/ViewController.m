//
//  ViewController.m
//  VideoTransition
//
//  Created by JinPeng on 16/12/9.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import "ViewController.h"
#import "IMVideoView.h"

@interface ViewController () <IMVideoViewDelegate>

// 视频转场视图
@property (nonatomic, strong) IMVideoView *videoView;
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

- (UIButton *)zoomInBtn
{
    if (!_zoomInBtn) {
        _zoomInBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 100, 40)];
        _zoomInBtn.hidden = YES;
        [_zoomInBtn setTitle:@"Zoom In" forState:UIControlStateNormal];
        [_zoomInBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_zoomInBtn addTarget:self action:@selector(zoomIn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_zoomInBtn];
    }
    [self.view bringSubviewToFront:_zoomInBtn];
    return _zoomInBtn;
}

- (void)zoomIn:(id)sender
{
    [self playVideoWithName:@"video1.mp4" withIndex:1];
}

- (UIButton *)zoomOutBtn
{
    if (!_zoomOutBtn) {
        _zoomOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 100, 40)];
        _zoomOutBtn.hidden = YES;
        [_zoomOutBtn setTitle:@"Zoom Out" forState:UIControlStateNormal];
        [_zoomOutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_zoomOutBtn addTarget:self action:@selector(zoomOut:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_zoomOutBtn];
    }
    [self.view bringSubviewToFront:_zoomOutBtn];
    return _zoomOutBtn;
}

- (void)zoomOut:(id)sender
{
    [self playVideoWithName:@"video2.mp4" withIndex:2];
}


#pragma mark - IMVideoTransitionDelegate

- (void)videoView:(IMVideoView *)videoView playDidFinishAtIndex:(NSInteger)index
{
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

- (void)videoView:(IMVideoView *)videoView playDidStartAtIndex:(NSInteger)index {
    [self.view bringSubviewToFront:self.videoView];
}

#pragma mark - mask image view

// 遮罩层有两个作用
// 1、掩盖视频加载时候的黑屏现象
// 2、视频播放完成之后的场景显示
- (void)loadMaskImageWithName:(NSString *)imageName
{
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
- (void)playVideoWithName:(NSString *)videoFile withIndex:(NSInteger)index
{
    if (!_videoView) {
        self.videoView = [[IMVideoView alloc] initWithFrame:self.view.bounds];
        self.videoView.delegate = self;
        [self.view addSubview:self.videoView];
    }
    
    self.videoView.index = index;
    
    // 在视频开始加载的时候先将遮罩层放在视频上面，等视频加载完成开始播放的时候将视频放到上面
    [self.view bringSubviewToFront:self.maskImageView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:videoFile ofType:nil];
    [self.videoView updatePlayerWithURL:[NSURL fileURLWithPath:path]];
}


@end
