//
//  KNMusicViewController.h
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNBaseViewController.h"

@interface KNMusicViewController : KNBaseViewController

@property (nonatomic ,strong) KNSongModel *songModel;           //歌曲模型


@property (nonatomic ,strong) KNSongListModel *songListModel;   //播放歌曲模型
@property (nonatomic ,strong) NSMutableArray *array;            //要播放歌曲的数组(KNSongListModel)
@property (nonatomic ,assign) NSInteger index;                  //当前播放的index

+(KNMusicViewController *)shareMusicViewController;
- (void)playMusicWithSongLink:(KNSongListModel*)model;

@property (nonatomic ,assign) NSUInteger isTabBar;
@end
