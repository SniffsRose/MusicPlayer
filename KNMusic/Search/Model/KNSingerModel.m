//
//  KNSingerModel.m
//  KNMusic
//
//  Created by KN on 15/9/5.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNSingerModel.h"

@implementation KNSingerModel

//表名
+(NSString *)getTableName
{
    return @"FMSongerInfor";
}
//表版本
+(int)getTableVersion
{
    return 1;
}
+(NSString *)getPrimaryKey
{
    return @"ting_uid";
}

-(NSMutableArray *)itemWith:(NSString *)name
{
    NSMutableArray * array = [KNSingerModel searchWithWhere:[NSString stringWithFormat:@"name like '%%%@%%'",name] orderBy:nil offset:0 count:0];
    NSMutableArray * temp = [NSMutableArray new];
    NSMutableArray * temp1 = [NSMutableArray new];
    for (KNSingerModel * sub in array) {
        if ([sub.name length]!=0) {
            if ([sub.company length]!=0) {
                [temp addObject:sub];
            }else{
                [temp1 addObject:sub];
            }
        }
    }
    [temp addObjectsFromArray:temp1];
    return temp;
}

-(NSMutableArray *)itemTop100
{
    NSMutableArray * array = [KNSingerModel searchWithWhere:[NSString stringWithFormat:@"'songs_total' >1000"] orderBy:nil offset:0 count:50];
    return array;//[self itemWith:@"李"];
}


@end
