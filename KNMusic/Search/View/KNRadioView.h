//
//  KNRadioView.h
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"
@class KNRadioView,KNLrcView,KNSongListModel,KNSongModel,KNImageView;
@class FSPlaylistItem;

@protocol KNRadioViewDelegate <NSObject>

/**
 *  停止播放按钮触发
 */
-(void)radioView:(KNRadioView *)view musicStop:(NSInteger)playModel;

/**
 *  上一曲按钮触发
 */
-(void)radioView:(KNRadioView *)view preSwitchMusic:(UIButton *)pre;

/**
 *  下一曲按钮触发
 */
-(void)radioView:(KNRadioView *)view nextSwitchMusic:(UIButton *)next;

/**
 *  播放列表按钮触发
 */
-(void)radioView:(KNRadioView *)view playListButton:(UIButton *)btn;

/**
 *  下载按钮触发
 */
-(void)radioView:(KNRadioView *)view downLoadButton:(UIButton *)btn;


/**
 *  收藏按钮触发
 */
-(void)radioView:(KNRadioView *)view collectButton:(UIButton *)btn;

@end




@interface KNRadioView : UIView<AudioPlayerDelegate>


-(void)setBackgroundImage:(UIImage*)image;

@property (nonatomic ,weak) KNLrcView *radiolrcView;

@property (nonatomic,strong) KNSongListModel * songlistModel;
@property (nonatomic,strong) KNSongModel * songModel;

//选中的item（FSPlaylistItem）
@property (nonatomic,strong) FSPlaylistItem *selectedPlaylistItem;
@property (nonatomic,assign) id <KNRadioViewDelegate>delegate;
@property (nonatomic,strong) UIButton * downLoadButton;

-(void)playButtonEvent;
-(void)setRadioViewLrc;

@end
