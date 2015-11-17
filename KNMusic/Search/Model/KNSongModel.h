//
//  KNSongModel.h
//  KNMusic
//
//  Created by KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNSongModel : NSObject

@property (nonatomic,assign) long long  queryId;
@property (nonatomic,assign) long long  songId;
@property (nonatomic,copy) NSString * songName;
@property (nonatomic,assign) long long  artistId;
@property (nonatomic,copy) NSString * artistName;
@property (nonatomic,assign) long long  albumId;
@property (nonatomic,copy) NSString * albumName;
@property (nonatomic,copy) NSString * songPicSmall;
@property (nonatomic,copy) NSString * songPicBig;
@property (nonatomic,copy) NSString * songPicRadio;
@property (nonatomic,copy) NSString * lrcLink;
@property (nonatomic,copy) NSString * version;
@property (nonatomic,assign) int copyType;
@property (nonatomic,assign) int time;
@property (nonatomic,assign) int linkCode;
@property (nonatomic,copy) NSString * songLink;
@property (nonatomic,copy) NSString * showLink;
@property (nonatomic,copy) NSString * format;
@property (nonatomic,assign) int rate;
@property (nonatomic,assign) long long  size;

- (void)initializeDB;

//删除一条记录
- (void)deleteData;

//增加一条记录
- (void)insetData;
@end
