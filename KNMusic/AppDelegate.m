//
//  AppDelegate.m
//  KNMusic
//
//  Created by KN on 15/9/3.
//  Copyright (c) 2015年 KN. All rights reserved.
//

#import "AppDelegate.h"
#import "KNMainTabBarController.h"
#import "Globle.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    Globle *globle = [Globle shareGloble];
    [globle copySqlitePath];
    globle.isPlaying = NO;
    
    //音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[KNMainTabBarController alloc]init];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

//    UIBackgroundTaskIdentifier ID = [application beginBackgroundTaskWithExpirationHandler:^{
//        // 当后台任务结束的时候调用
//        [application endBackgroundTask:ID];
//        
//    }];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [Globle shareGloble].isApplicationEnterBackground = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:KNRadioViewSetSongInformationNotification object:nil userInfo:nil];
}
//后台遥控器,根据遥控指令发出通知
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    NSString * statu = nil;
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
                statu = @"UIEventSubtypeRemoteControlPause";
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                statu = @"UIEventSubtypeRemoteControlPreviousTrack";
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                statu = @"UIEventSubtypeRemoteControlNextTrack";
                break;
            case UIEventSubtypeRemoteControlPlay:
                statu = @"UIEventSubtypeRemoteControlPlay";
                break;
            default:
                break;
        }
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:statu forKey:@"keyStatus"];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNRadioViewStatusNotifiation object:nil userInfo:dict];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [Globle shareGloble].isApplicationEnterBackground = NO;
 
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
