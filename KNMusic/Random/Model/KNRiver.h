//
//  KNRiver.h
//  KNMusic
//
//  Created by KN on 15/9/9.
//  Copyright © 2015年 KN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KNSongListModel.h"
@interface KNRiver : NSObject

//河中的对象

/**
 *  歌曲信息
 */
@property (nonatomic ,strong) KNSongListModel *songListModel;
/**
 *  歌曲图片
 */
@property (nonatomic ,strong) UIImage *image;
@property (nonatomic ,strong) UIImageView *imageView;


@end
