//
//  KNDataEngine.m
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNDataEngine.h"
#import "NSObject+MJKeyValue.h"
#import "KNSongListModel.h"   //songlistModel   and   songList
#import "KNSongModel.h"



#define DocumentsPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
NSString * songlist= @"songlist";
NSString * error_code = @"error_code";
@implementation KNDataEngine


-(MKNetworkOperation *)getSingerSongListWith:(long long)tinguid :(int)number
                       WithCompletionHandler:(KNSongListModelResponseBlock)completion
                                errorHandler:(MKNKErrorBlock)errorHandler
{
    self.showError = YES;
    //歌手歌曲接口：http://tingapi.ting.baidu.com/v1/restserver/ting?from=android&version=2.4.0&method=baidu.ting.artist.getSongList&format=json&order=2&tinguid=7994&offset=0&limits=50   tinguid:   limits:。。。
    NSString *urlPath = [NSString stringWithFormat:@"/v1/restserver/ting?from=android&version=2.4.0&method=baidu.ting.artist.getSongList&format=json&order=2&tinguid=%lld&offset=0&limits=%d",tinguid,number];
    MKNetworkOperation *op = [self operationWithPath:urlPath];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        id respJson = [completedOperation responseJSON];
        if ([self checkError:respJson]) {
            return ;
        }
        //        NSLog(@"resp:%@",respJson);
        KNSongList * list = [KNSongList new];
        @try{
            NSDictionary * dictionary = respJson;
            if ([[dictionary allKeys] count]>1) {
                
                //字典转模型
                list = [list setKeyValues:dictionary];
                
//                NSLog(@"%@",list);
                //取出歌曲列表数组
                NSArray * temp = [dictionary objectForKey:@"songlist"];
                
                for (NSDictionary * dict in temp) {
                    KNSongListModel * model = [KNSongListModel new];
                    
                    //字典转模型
                    model = [model setKeyValues:dict];
                    [list.songLists addObject:model];
                }
            }else{
                int errorcode = [[dictionary objectForKey:error_code] intValue];
                NSLog(@"%d",errorcode);
            }
            completion(list);
        }
        @catch (NSException *exception) {
            KHError *appError = [[KHError alloc] initWithDomain:kAppErrorDomain code:100 userInfo:nil];
            appError.reason = kErrorParse;
            errorHandler(appError);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ERROR:%@",error);
        KHError *appError = [[KHError alloc] initWithMKNetworkOperation:completedOperation error:error];
        errorHandler(appError);
        
    }];
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation *)getSongInformationWith:(long long)songID
                        WithCompletionHandler:(KNSongModelResponseBlock)completion
                                 errorHandler:(MKNKErrorBlock)errorHandler
{
    //ting.baidu.com/data/music/links?songIds=120022293
    
    self.showError = YES;
    NSString *urlPath = [NSString stringWithFormat:@"/data/music/links?songIds=%lld",songID];
    KNNetworkEngine * netwrok = [self initWithHostName:@"ting.baidu.com"];
    
    MKNetworkOperation *op = [netwrok operationWithPath:urlPath];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        id respJson = [completedOperation responseJSON];
        if ([self checkError:respJson]) {
            return ;
        }
        //        NSLog(@"resp:%@",respJson);
        KNSongModel * song = [KNSongModel new];
        song.songId = songID;
        @try{
            NSDictionary * dictionary = respJson;
            if ([[dictionary allKeys] count]>1) {
                NSDictionary * data = [dictionary objectForKey:@"data"];
                NSArray * songList = [data objectForKey:@"songList"];
                for (NSDictionary * sub in songList) {
                    song.songLink = [sub objectForKey:@"songLink"];
                    NSRange range = [song.songLink rangeOfString:@"src"];
                    if (range.location != 2147483647 && range.length != 0) {
                        NSString * temp = [song.songLink substringToIndex:range.location-1];
                        song.songLink = temp;
                    }
                    song.songName = [sub objectForKey:@"songName"];
                    song.lrcLink = [sub objectForKey:@"lrcLink"];
                    song.songPicBig = [sub objectForKey:@"songPicBig"];
                    song.time = [[sub objectForKey:@"time"] intValue];
                }
            }else{
                int errorcode = [[dictionary objectForKey:error_code] intValue];
                NSLog(@"%d",errorcode);
            }
            completion(song);
        }
        @catch (NSException *exception) {
            KHError *appError = [[KHError alloc] initWithDomain:kAppErrorDomain code:100 userInfo:nil];
            appError.reason = kErrorParse;
            errorHandler(appError);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ERROR:%@",error);
        KHError *appError = [[KHError alloc] initWithMKNetworkOperation:completedOperation error:error];
        errorHandler(appError);
        
    }];
    [self enqueueOperation:op];
    return op;
}

//songLink是完整地址
//lrclink是域名下的子地址
-(MKNetworkOperation *)getSongLrcWith:(long long)tingUid :(long long)songID :(NSString *)lrclink
                WithCompletionHandler:(KNSongLrcResponseBlock)completion
                         errorHandler:(MKNKErrorBlock)errorHandler
{
    self.showError = YES;
    KNNetworkEngine * netwrok = [self initWithHostName:@"ting.baidu.com"];

    MKNetworkOperation *op = [netwrok operationWithPath:lrclink];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData * respData = [completedOperation responseData];
        if ([self checkError:respData]) {
            return ;
        }
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *UIDPath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",tingUid]];
        NSString * SIDPath = [UIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",songID]];
        if (![fileMgr fileExistsAtPath:UIDPath]) {
            BOOL creatUID = [fileMgr createDirectoryAtPath:UIDPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (creatUID) {
                NSLog(@"建立歌手文件夹成功");
            }
        }
        if (![fileMgr fileExistsAtPath:SIDPath]) {
            BOOL creatSID = [fileMgr createDirectoryAtPath:SIDPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (creatSID) {
                NSLog(@"建立歌曲文件夹成功");
            }
        }
        BOOL sucess = NO;
        NSString * filePath  = [SIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.lrc",songID]];
        if (![fileMgr fileExistsAtPath:filePath]) {
            BOOL creat =  [fileMgr createFileAtPath:filePath contents:respData attributes:nil];
            if (creat) {
                NSLog(@"lrc文件保存成功");
                sucess = YES;
            }
        }else{
            sucess = YES;
        }
        //        NSLog(@"resp:%@",respData);
        @try{
            completion(sucess,filePath);
        }
        @catch (NSException *exception) {
            KHError *appError = [[KHError alloc] initWithDomain:kAppErrorDomain code:100 userInfo:nil];
            appError.reason = kErrorParse;
            errorHandler(appError);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ERROR:%@",error);
        KHError *appError = [[KHError alloc] initWithMKNetworkOperation:completedOperation error:error];
        errorHandler(appError);
        
    }];
    [self enqueueOperation:op];
    return op;
    
}

-(MKNetworkOperation *)downLoadSongWith:(long long)tingUid :(long long)songID :(NSString *)songLink
                  WithCompletionHandler:(KNSongLinkDownLoadResponseBlock)completion
                           errorHandler:(MKNKErrorBlock)errorHandler
{
    self.showError = YES;
    MKNetworkOperation *op = [self operationWithURLString:songLink];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData * respData = [completedOperation responseData];
        if ([self checkError:respData]) {
            return ;
        }
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *UIDPath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",tingUid]];
        NSString * SIDPath = [UIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",songID]];
        if (![fileMgr fileExistsAtPath:UIDPath]) {
            BOOL creatUID = [fileMgr createDirectoryAtPath:UIDPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (creatUID) {
                NSLog(@"建立歌手文件夹成功");
            }
        }
        if (![fileMgr fileExistsAtPath:SIDPath]) {
            BOOL creatSID = [fileMgr createDirectoryAtPath:SIDPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (creatSID) {
                NSLog(@"建立歌曲文件夹成功");
            }
        }
        BOOL sucess = NO;
        NSString * filePath  = [SIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.mp3",songID]];
        if (![fileMgr fileExistsAtPath:filePath]) {
            BOOL creat =  [fileMgr createFileAtPath:filePath contents:respData attributes:nil];
            
            if (creat) {
                NSLog(@"mp3文件保存成功");
                sucess = YES;
            }
        }else{
            sucess = YES;
        }
        //        NSLog(@"resp:%@",respData);
        @try{
            completion(sucess,filePath);
        }
        @catch (NSException *exception) {
            KHError *appError = [[KHError alloc] initWithDomain:kAppErrorDomain code:100 userInfo:nil];
            appError.reason = kErrorParse;
            errorHandler(appError);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ERROR:%@",error);
        KHError *appError = [[KHError alloc] initWithMKNetworkOperation:completedOperation error:error];
        errorHandler(appError);
        
    }];
    
    //下载的进度变化后调用的block
    [op onDownloadProgressChanged:^(double progress) {
        NSLog(@"%.2f",progress*100.0);
    }];
    
    [self enqueueOperation:op];
    return op;
    
}

@end
