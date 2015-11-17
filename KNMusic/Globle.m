//
//  Globle.m
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "Globle.h"
#import "KNSongModel.h"
NSString * KNRadioViewStatusNotifiation = @"KNRFRadioViewStatusNotifiation";
NSString * KNRadioViewSetSongInformationNotification= @"KNRFRadioViewSetSongInformationNotification";
@implementation Globle
+(BOOL)isPlaying{
    return  [self shareGloble].isPlaying;
}
+(Globle*)shareGloble{
    static Globle *globle=nil;
    if (globle==nil) {
        globle=[[Globle alloc] init];
    }
    return globle;
}

-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

//拷贝自带的歌手数据库到沙盒中
-(void)copySqlitePath
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dbPath = [DocumentsPath stringByAppendingPathComponent:@"FreeMusic.db"];
    
    if (![fileMgr fileExistsAtPath:dbPath]) {
        NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"FreeMusic" ofType:@"db"];
        NSLog(@"%@",srcPath);
        [fileMgr copyItemAtPath:srcPath toPath:dbPath error:NULL];
//        KNSongModel *model = [[KNSongModel alloc]init];
//        
//        //需要新建的表
//        [model initializeDB];
    }
}

@end
