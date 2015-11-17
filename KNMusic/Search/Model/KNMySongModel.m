//
//  KNMySongModel.m
//  KNMusic
//
//  Created by KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNMySongModel.h"

@implementation KNMySongModel

//表名
+(NSString *)getTableName
{
    return @"FMMySong";
}
//表版本
+(int)getTableVersion
{
    return 1;
}
+(NSString *)getPrimaryKey
{
    return @"song_id";
}

@end
