//
//  KNSongTool.m
//  KNMusic
//
//  Created by KN on 15/9/9.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNSongTool.h"
#import "KNDataEngine.h"
#import "KNSingerModel.h"
#import "KNSongListModel.h"
#import "KNRiver.h"
#import "NSObject+MJKeyValue.h"
#import "UIImageView+WebCache.h"
#define DocumentsPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
static  NSInteger curIndex;
static NSArray *allsonglist;
@implementation KNSongTool

//+ (void)initialize{
//    [super initialize];
//    songArray = [NSMutableArray array];
//    for (int i = 0 ; i < 20; i++) {
//        [self getRandomSongListModelSuccess:^(KNSongListModel *song) {
//            KNRiver *river = [KNRiver new];
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:song.pic_big]];
//            UIImage *image = [UIImage imageWithData:data];
//            river.image = image;
//            river.songListModel = song;
//            [songArray addObject:river];
//        }];
//        
//    }
//    KNSingerModel *model = [KNSingerModel new];
//    allSinger = [model itemTop100];
//    curIndex = 0;
//}
//+(KNSingerModel*)getRandomSinger{
//    if(allSinger == nil){
//        KNSingerModel *model = [KNSingerModel new];
//        allSinger = [model itemTop100];
//    }
//    return allSinger[arc4random()%50];
//}
//
//+(void)getRandomSongWithSingerModel:(KNSingerModel*)singerModel success:(void(^)(KNSongListModel* song))success{
//    NSInteger songsTotal = singerModel.songs_total;
//    songsTotal = songsTotal > 10 ? 10 : songsTotal;
//    NSInteger randomIndex = arc4random() % songsTotal;
//    __block NSArray *array = [NSArray array];
//    //获取更多数据，获取后停止加载动画
//    KNDataEngine *network = [[KNDataEngine alloc]init];
//    [network getSingerSongListWith:singerModel.ting_uid :(int)randomIndex WithCompletionHandler:^(KNSongList *songList) {
//        array = songList.songLists;
//        if (success) {
//            success([array lastObject]);
//        }
//    } errorHandler:nil];
//    
//}
//+ (void)getRandomSongListModelSuccess:(void(^)(KNSongListModel *song))success{
//    
//    KNSingerModel *singer =[self getRandomSinger];
//    [self getRandomSongWithSingerModel:singer success:^(KNSongListModel *song) {
//        if(success){
//            success(song);
//        }
//    }];
//
//}

//+(KNRiver*)getOneRiver{
//    KNRiver *river = songArray[curIndex];
//    curIndex++;
//    [self cacheRiver];
//    return river;
//}
//+(void)cacheRiver{
//    [self getRandomSongListModelSuccess:^(KNSongListModel *song) {
//        KNRiver *river = [KNRiver new];
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:song.pic_big]];
//        UIImage *image = [UIImage imageWithData:data];
//        river.image = image;
//        river.songListModel = song;
//        [songArray removeObjectAtIndex:0];
//        [songArray addObject:river];
//        curIndex--;
//    }];
//   
//    
//}

+(BOOL)isHaveSongMusic{
    
    allsonglist = [KNSongListModel searchWithWhere:nil orderBy:@"song_id" offset:0 count:9999];
    curIndex = 0;

    return allsonglist.count;
}

+(KNSongListModel*)getOneSongList{
    if(allsonglist == nil){
        allsonglist = [KNSongListModel searchWithWhere:nil orderBy:@"song_id" offset:0 count:9999];
        curIndex = -1;
    }
    curIndex++;
    if(curIndex >= allsonglist.count){
        curIndex = 0;
    }
    return allsonglist[curIndex];
    
}

+(KNRiver*)getOneRiver{
    
    KNSongListModel *songListModel = [self getOneSongList];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *UIDPath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",songListModel.ting_uid]];
    NSString * SIDPath = [UIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",songListModel.song_id]];
    NSString * filePath  = [SIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.png",songListModel.song_id]];
    UIImage *image = nil;
    UIImageView *imageView = [[UIImageView alloc]init];
    if (![fileMgr fileExistsAtPath:filePath]) {
        
//        [imageView sd_setImageWithURL:[NSURL URLWithString:songListModel.pic_big]];
    }else{
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        image = [UIImage imageWithData:data];
        imageView.image = image;
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.size.height / 3.0, imageView.size.width, imageView.size.height / 3.0)];
    label.text = songListModel.title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [self randomColor];
    [imageView addSubview:label];
    
    KNRiver *river = [[KNRiver alloc]init];
    river.imageView = imageView;
    river.songListModel = songListModel;
    river.image = image;
    
    return river;
}
+ (UIColor *)randomColor{
   
    CGFloat r = [self getRandomFloat];
    CGFloat g = [self getRandomFloat];
    CGFloat b = [self getRandomFloat];
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}
+ (CGFloat)getRandomFloat{
    CGFloat r = arc4random()%10000;
    return r/10000.0;
}
@end
