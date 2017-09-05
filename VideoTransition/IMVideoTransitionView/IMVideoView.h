//
//  IMVideoView.h
//  Video Transition
//
//  Created by JinPeng on 16/12/9.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class IMVideoView;

@protocol IMVideoViewDelegate <NSObject>
- (void)videoView:(IMVideoView *)videoView playDidStartAtIndex:(NSInteger)index;
- (void)videoView:(IMVideoView *)videoView playDidFinishAtIndex:(NSInteger)index;
@end

@interface IMVideoView : UIView

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, weak) id <IMVideoViewDelegate> delegate;

// 这个仅用于告诉代理哪个视频播放完成，可以使用一切便于识别的变量
@property (nonatomic, assign) NSInteger index;

- (void)updatePlayerWithURL:(NSURL *)url;

@end
