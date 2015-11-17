//
//  KNSongListModel.m
//  KNMusic
//
//  Created by KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNSongListModel.h"

static LKDBHelper *dbHelper;
@implementation KNSongListModel

//表名
+(NSString *)getTableName
{
    return @"FMSongListTable";
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
- (void)insetData{
    [dbHelper insertToDB:self];
    
}
- (void)deleteData{
    [dbHelper deleteToDB:self];
}




@end

@implementation KNSongList
-(id)init
{
    if (self = [super init]) {
        self.songLists = [NSMutableArray new];
        

    }
    return self;
}



@end
