//
//  KNSongTool.h
//  KNMusic
//
//  Created by KN on 15/9/9.
//  Copyright © 2015年 KN. All rights reserved.
//

//随机视图工具
#import <Foundation/Foundation.h>
#import "KNRiver.h"
@interface KNSongTool : NSObject


/**
 *  获取一个歌曲河中的对象(KNRiver)
 */
+(KNRiver*)getOneRiver;


/**
 *  检测是否有可用数据、加载最新数据
 */
+(BOOL)isHaveSongMusic;
@end
