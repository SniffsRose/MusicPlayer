//
//  KNSongModel.m
//  KNMusic
//
//  Created by KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNSongModel.h"

static LKDBHelper *dbHelper;
@implementation KNSongModel
//表名
+(NSString *)getTableName
{
    return @"FMSongModel";
}
//表版本
+(int)getTableVersion
{
    return 1;
}
+(NSString *)getPrimaryKey
{
    return @"songId";
}
- (instancetype)init{
    if([super init]){
        dbHelper = [LKDBHelper getUsingLKDBHelper];
        //清楚库中表的所有记录
        //        [dbHelper dropAllTable];
        
        //库中创建表
        //        [dbHelper createTableWithModelClass:[KNSongListModel class]];
    }
    return self;
}
- (void)initializeDB{
    [dbHelper createTableWithModelClass:[KNSongModel class]];
}
- (void)insetData{
    [dbHelper insertToDB:self];
    
}
- (void)deleteData{
    [dbHelper deleteToDB:self];
}

@end
