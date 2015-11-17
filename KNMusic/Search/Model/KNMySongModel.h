//
//  KNMySongModel.h
//  KNMusic
//
//  Created by KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNMySongModel : NSObject

@property (nonatomic,assign) long long ting_uid;
@property (nonatomic,assign) long long song_id;
@property (nonatomic,copy) NSString * songName;
@property (nonatomic,copy) NSString * lrcLink;
@property (nonatomic,copy) NSString * songLink;
@property (nonatomic,copy) NSString * songPicBig;
@property (nonatomic,assign) long long albumid;

@end
