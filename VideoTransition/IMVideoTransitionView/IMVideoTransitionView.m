//
//  IMVideoTransitionView.m
//  VideoTransition
//
//  Created by JinPeng on 16/12/9.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import "IMVideoTransitionView.h"

@implementation IMVideoTransitionView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
}

- (id)initWithFrame:(CGRect)frame withUrl:(NSURL *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        if (url) {
            [self startPlayerWithUrl:url];
        }
    }
    return self;
}

- (void)startPlayerWithUrl:(NSURL *)url
{
    if (!_moviePlayer) {
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        self.moviePlayer.controlStyle = MPMovieControlStyleNone;
        self.moviePlayer.fullscreen = YES;
        self.moviePlayer.view.frame = self.bounds;
        self.moviePlayer.scalingMode = MPMovieScalingModeFill;
        self.moviePlayer.shouldAutoplay = YES;
        [self addSubview:self.moviePlayer.view];
        [self.moviePlayer prepareToPlay];
        
        // 监听播放完成的消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerDidFinish)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:_moviePlayer];
    }
}

- (void)moviePlayerDidFinish
{
    if (_delegate && [_delegate respondsToSelector:@selector(videoTransitionView:playerDidFinishAtIndex:)]) {
        [_delegate videoTransitionView:self playerDidFinishAtIndex:self.index];
    }
    
    [_moviePlayer.view removeFromSuperview];
    _moviePlayer = nil;
    
    [self removeFromSuperview];
}

@end
