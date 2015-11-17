//
//  Globle.h
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DocumentsPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

extern NSString * KNRadioViewStatusNotifiation;
extern NSString * KNRadioViewSetSongInformationNotification;
@interface Globle : NSObject
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isApplicationEnterBackground;
-(void)copySqlitePath;
+(Globle*)shareGloble;
+(BOOL)isPlaying;

@end
