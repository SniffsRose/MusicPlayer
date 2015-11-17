//
//  KNDataEngine.h
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KNNetworkEngine.h"
/*
 OS9引入了新特性App Transport Security (ATS)。详情：App Transport Security (ATS)
 新特性要求App内访问的网络必须使用HTTPS协议。意思是Api接口以后必须是HTTPS
 但是现在公司的项目使用的是HTTP协议，使用私有加密方式保证数据安全。现在也不能马上改成HTTPS协议传输。
 暂时解决办法:
 在Info.plist中添加NSAppTransportSecurity类型Dictionary。
 在NSAppTransportSecurity下添加NSAllowsArbitraryLoads类型Boolean,值设为YES
*/

@class KNSongListModel,KNSongList,KNSongModel;

@interface KNDataEngine : KNNetworkEngine

typedef void (^SalesResponseBlock) (NSArray *array);

typedef void (^KNSongListModelResponseBlock) (KNSongList *songList);
typedef void (^KNSongModelResponseBlock) (KNSongModel *songModel);
typedef void (^KNSongLrcResponseBlock)(BOOL sucess,NSString * path);
typedef void (^KNSongLinkDownLoadResponseBlock)(BOOL sucess,NSString * path);

-(MKNetworkOperation *)getSingerSongListWith:(long long)tinguid :(int) number
                       WithCompletionHandler:(KNSongListModelResponseBlock)completion
                                errorHandler:(MKNKErrorBlock)errorHandler;

-(MKNetworkOperation *)getSongInformationWith:(long long)songID
                        WithCompletionHandler:(KNSongModelResponseBlock)completion
                                 errorHandler:(MKNKErrorBlock)errorHandler;

-(MKNetworkOperation *)getSongLrcWith:(long long)tingUid :(long long)songID :(NSString *)lrclink
                WithCompletionHandler:(KNSongLrcResponseBlock)completion
                         errorHandler:(MKNKErrorBlock)errorHandler;

-(MKNetworkOperation *)downLoadSongWith:(long long)tingUid :(long long)songID :(NSString *)songLink
                  WithCompletionHandler:(KNSongLinkDownLoadResponseBlock)completion
                           errorHandler:(MKNKErrorBlock)errorHandler;


@end
