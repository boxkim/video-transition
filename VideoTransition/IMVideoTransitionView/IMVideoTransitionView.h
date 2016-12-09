//
//  IMVideoTransitionView.h
//  VideoTransition
//
//  Created by JinPeng on 16/12/9.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class IMVideoTransitionView;

@protocol IMVideoTransitionDelegate <NSObject>
- (void)videoTransitionView:(IMVideoTransitionView *)transitionView playerDidFinishAtIndex:(NSInteger)index;
@end

@interface IMVideoTransitionView : UIView

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, weak) id <IMVideoTransitionDelegate> delegate;

// 这个仅用于告诉代理哪个视频播放完成，可以使用一切便于识别的变量
@property (nonatomic, assign) NSInteger index;

- (id)initWithFrame:(CGRect)frame withUrl:(NSURL *)url;

@end
