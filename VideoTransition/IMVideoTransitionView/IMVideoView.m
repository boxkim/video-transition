//
//  IMVideoView.h.m
//  Video Transition
//
//  Created by JinPeng on 16/12/9.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import "IMVideoView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface IMVideoView ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end




@implementation IMVideoView

- (void)dealloc {
    [self removeObserveAndNOtification];
}

- (void)removeObserveAndNOtification {
    [_player replaceCurrentItemWithPlayerItem:nil];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _player = [[AVPlayer alloc] init];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = self.bounds;
        [self.layer addSublayer:_playerLayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackFinished:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
    }
    return self;
}

- (void)updatePlayerWithURL:(NSURL *)url {
    _playerItem = [AVPlayerItem playerItemWithURL:url];
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
    [_playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue]; // 获取更改后的状态
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            [_player play];
            if (_delegate && [_delegate respondsToSelector:@selector(videoView:playDidStartAtIndex:)]) {
                [_delegate videoView:self playDidStartAtIndex:self.index];
            }
        }
        else if (status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
        else {
            NSLog(@"AVPlayerStatusUnknown");
        }
    }
}

- (void)playbackFinished:(NSNotification *)notification {
    NSLog(@"视频播放完成通知");
    //_playerItem = [notification object];
    // 是否无限循环
    //[_playerItem seekToTime:kCMTimeZero]; // 跳转到初始
    //[_player play]; // 是否无限循环
    if (_delegate && [_delegate respondsToSelector:@selector(videoView:playDidFinishAtIndex:)]) {
        [_delegate videoView:self playDidFinishAtIndex:self.index];
    }
    
    // 释放视频资源，取消监听
    [_player replaceCurrentItemWithPlayerItem:nil];
    [_playerItem removeObserver:self forKeyPath:@"status"];
}

@end
